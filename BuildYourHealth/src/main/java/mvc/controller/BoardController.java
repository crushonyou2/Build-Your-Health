package mvc.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.io.File;
import java.util.List;
import java.util.UUID;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import mvc.model.BoardDAO;
import mvc.model.BoardDTO;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;


public class BoardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static final int LISTCOUNT = 5; 

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String RequestURI = request.getRequestURI();
		String contextPath = request.getContextPath();
		String command = RequestURI.substring(contextPath.length());
		
		response.setContentType("text/html; charset=utf-8");
		request.setCharacterEncoding("utf-8");
	
		if (command.equals("/BoardListAction.do")) {//등록된 글 목록 페이지 출력하기
			requestBoardList(request);
			RequestDispatcher rd = request.getRequestDispatcher("./board/list.jsp");
			rd.forward(request, response);
		} else if (command.equals("/BoardWriteForm.do")) { //글 등록 페이지 출력
				requestLoginName(request);
				RequestDispatcher rd = request.getRequestDispatcher("./board/writeForm.jsp");
				rd.forward(request, response);				
		} else if (command.equals("/BoardWriteAction.do")) {//새로운 글 등록
				requestBoardWrite(request);
				RequestDispatcher rd = request.getRequestDispatcher("/BoardListAction.do");
				rd.forward(request, response);						
		} else if (command.equals("/BoardViewAction.do")) {//선택된 글 상자 페이지 가져오기
				requestBoardView(request);
				RequestDispatcher rd = request.getRequestDispatcher("/BoardView.do");
				rd.forward(request, response);						
		} else if (command.equals("/BoardView.do")) {  //글 상세 페이지 출
				RequestDispatcher rd = request.getRequestDispatcher("./board/view.jsp");
				rd.forward(request, response);	
		} else if (command.equals("/BoardUpdateAction.do")) { //선택된 글 수정하기
				requestBoardUpdate(request);
				RequestDispatcher rd = request.getRequestDispatcher("/BoardListAction.do");
				rd.forward(request, response);
		}else if (command.equals("/BoardDeleteAction.do")) { //선택된 글 삭제하기
				requestBoardDelete(request);
				RequestDispatcher rd = request.getRequestDispatcher("/BoardListAction.do");
				rd.forward(request, response);				
		} 
	}
	//등록된 글 목록 가져오기
	public void requestBoardList(HttpServletRequest request) {
	    try {
	        BoardDAO dao = BoardDAO.getInstance();
	        int pageNum = 1;
	        int limit = LISTCOUNT;

	        if (request.getParameter("pageNum") != null)
	            pageNum = Integer.parseInt(request.getParameter("pageNum"));

	        String items = request.getParameter("items");
	        String text = request.getParameter("text");

	        int total_record = dao.getListCount(items, text);
	        List<BoardDTO> boardlist = dao.getBoardList(pageNum, limit, items, text);

	        int total_page = (int) Math.ceil((double) total_record / limit);
	        total_page = (total_page < 1) ? 1 : total_page;

	        request.setAttribute("pageNum", pageNum);
	        request.setAttribute("total_page", total_page);
	        request.setAttribute("total_record", total_record);
	        request.setAttribute("boardlist", boardlist);
	    } catch (Exception e) {
	        e.printStackTrace();
	        request.setAttribute("errorMessage", "게시판 목록을 불러오는 중 오류가 발생했습니다.");
	    }
	}

	//인증된 사용자명 가져오기
	public void requestLoginName(HttpServletRequest request){
					
		String id = request.getParameter("id");
		
		BoardDAO  dao = BoardDAO.getInstance();
		
		String name = dao.getLoginNameById(id);		
		
		request.setAttribute("name", name);									
	}
   //새로운 글 등록하기
	public void requestBoardWrite(HttpServletRequest request) {
	    BoardDAO dao = BoardDAO.getInstance();
	    BoardDTO board = new BoardDTO();

	    // 파일 업로드를 위한 설정
	    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	    if (!isMultipart) {
	        // 에러 처리: 멀티파트 데이터가 아닐 경우
	        System.out.println("Form must has enctype=multipart/form-data.");
	        return;
	    }

	    DiskFileItemFactory factory = new DiskFileItemFactory();
	    factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
	    ServletFileUpload upload = new ServletFileUpload(factory);

	    // 업로드 가능한 최대 파일 크기 설정 (예: 10MB)
	    upload.setSizeMax(10 * 1024 * 1024);

	    try {
	        List<FileItem> formItems = upload.parseRequest(request);

	        if (formItems != null && formItems.size() > 0) {
	            for (FileItem item : formItems) {
	                if (!item.isFormField()) {
	                    // 파일 필드 처리
	                    String fileName = new File(item.getName()).getName();
	                    if (fileName != null && !fileName.isEmpty()) {
	                        // 파일 이름 중복 방지를 위한 UUID 적용
	                        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
	                        String uploadPath = request.getServletContext().getRealPath("/uploads");
	                        File uploadDir = new File(uploadPath);
	                        if (!uploadDir.exists()) {
	                            uploadDir.mkdir();
	                        }
	                        String filePath = uploadPath + File.separator + uniqueFileName;
	                        File storeFile = new File(filePath);
	                        item.write(storeFile);
	                        board.setImageFileName(uniqueFileName); // DTO에 파일명 설정
	                    }
	                } else {
	                    // 일반 폼 필드 처리
	                    String fieldName = item.getFieldName();
	                    String fieldValue = item.getString("UTF-8");

	                    if (fieldName.equals("id")) {
	                        board.setId(fieldValue);
	                    } else if (fieldName.equals("name")) {
	                        board.setName(fieldValue);
	                    } else if (fieldName.equals("subject")) {
	                        board.setSubject(fieldValue);
	                    } else if (fieldName.equals("content")) {
	                        board.setContent(fieldValue);
	                    }
	                }
	            }
	        }

	        // 게시글 등록 날짜 및 IP 설정
	        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy/MM/dd(HH:mm:ss)");
	        String regist_day = formatter.format(new java.util.Date());

	        board.setHit(0);
	        board.setRegist_day(regist_day);
	        board.setIp(request.getRemoteAddr());

	        // 게시글 데이터베이스에 저장
	        dao.insertBoard(board);

	    } catch (Exception ex) {
	        ex.printStackTrace();
	        System.out.println("Exception in uploading file.");
	    }
	}

	//선택된 글 상세 페이지 가져오기
	public void requestBoardView(HttpServletRequest request){
					
		BoardDAO dao = BoardDAO.getInstance();
		int num = Integer.parseInt(request.getParameter("num"));
		int pageNum = Integer.parseInt(request.getParameter("pageNum"));	
		
		BoardDTO board = new BoardDTO();
		board = dao.getBoardByNum(num, pageNum);		
		
		request.setAttribute("num", num);		 
   		request.setAttribute("page", pageNum); 
   		request.setAttribute("board", board);   									
	}
	 //선택된 글 내용 수정하기
	public void requestBoardUpdate(HttpServletRequest request) {
	    BoardDAO dao = BoardDAO.getInstance();
	    BoardDTO board = new BoardDTO();

	    int num = Integer.parseInt(request.getParameter("num"));
	    board.setNum(num);

	    // 파일 업로드를 위한 설정
	    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	    if (isMultipart) {
	        DiskFileItemFactory factory = new DiskFileItemFactory();
	        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
	        ServletFileUpload upload = new ServletFileUpload(factory);
	        upload.setSizeMax(10 * 1024 * 1024); // 최대 10MB

	        try {
	            List<FileItem> formItems = upload.parseRequest(request);

	            for (FileItem item : formItems) {
	                if (!item.isFormField()) {
	                    // 파일 필드 처리
	                    String fileName = new File(item.getName()).getName();
	                    if (fileName != null && !fileName.isEmpty()) {
	                        // 기존 이미지 파일 삭제
	                        BoardDTO existingBoard = dao.getBoardByNum(num, 1);
	                        String existingFileName = existingBoard.getImageFileName();
	                        if (existingFileName != null && !existingFileName.isEmpty()) {
	                            String uploadPath = request.getServletContext().getRealPath("/uploads");
	                            File existingFile = new File(uploadPath + File.separator + existingFileName);
	                            if (existingFile.exists()) {
	                                existingFile.delete();
	                            }
	                        }

	                        // 새로운 이미지 파일 저장
	                        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
	                        String uploadPath = request.getServletContext().getRealPath("/uploads");
	                        File uploadDir = new File(uploadPath);
	                        if (!uploadDir.exists()) {
	                            uploadDir.mkdir();
	                        }
	                        String filePath = uploadPath + File.separator + uniqueFileName;
	                        File storeFile = new File(filePath);
	                        item.write(storeFile);
	                        board.setImageFileName(uniqueFileName);
	                    }
	                } else {
	                    // 일반 폼 필드 처리
	                    String fieldName = item.getFieldName();
	                    String fieldValue = item.getString("UTF-8");

	                    if (fieldName.equals("name")) {
	                        board.setName(fieldValue);
	                    } else if (fieldName.equals("subject")) {
	                        board.setSubject(fieldValue);
	                    } else if (fieldName.equals("content")) {
	                        board.setContent(fieldValue);
	                    }
	                }
	            }

	            // 이미지 파일을 변경하지 않았을 경우 기존 파일명 유지
	            if (board.getImageFileName() == null) {
	                BoardDTO existingBoard = dao.getBoardByNum(num, 1);
	                board.setImageFileName(existingBoard.getImageFileName());
	            }

	            dao.updateBoard(board);

	        } catch (Exception ex) {
	            ex.printStackTrace();
	            System.out.println("Exception in updating board with file.");
	        }
	    } else {
	        // 멀티파트 폼 데이터가 아닐 경우 처리 (예외 상황)
	        System.out.println("Form must has enctype=multipart/form-data.");
	    }
	}

	//선택된 글 삭제하기
	public void requestBoardDelete(HttpServletRequest request){
					
		int num = Integer.parseInt(request.getParameter("num"));
		int pageNum = Integer.parseInt(request.getParameter("pageNum"));	
		
		BoardDAO dao = BoardDAO.getInstance();
		dao.deleteBoard(num);							
	}	
}
