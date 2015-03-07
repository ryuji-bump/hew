package jp.ac.hal.tokyo.Servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class Download
 */
@WebServlet("/Download")
public class Download extends HttpServlet {

	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		//ダウンロードフォルダパス
		final String FILEPATH = "/upload/";

		//メッセージ
		final String DOWNLOADFAIL = "ダウンロードに失敗しました。";
		final String NOTEXISTDLFILE = "ダウンロードするファイルが存在しません。";
		final String SUCCESSDOWNLOAD = "ダウンロードが成功しました。";

		//メッセージ格納ArrayList定義
		ArrayList<String> msg = new ArrayList<String>();

		//ダウンロードするファイル名を取得
		String filename = request.getParameter("filename");
		
		//アプリアップロードユーザーID取得
		String userId = request.getParameter("userId");
		
		System.out.println(filename + " " + userId);

	    OutputStream out = null;
	    InputStream in = null;

	    //ダウンロードファイルの存在チェック
	    File file = new File(FILEPATH + userId + "/" + filename);

	    if(file.exists())
	    {

		    try {

		        //response.setContentType("application/octet-stream");
		        response.setContentType("application/force-download");
		    	response.setHeader("Content-Disposition","filename=\""+ filename +"\"");
		        in = new FileInputStream(FILEPATH + userId + "/" + filename);
		        out = response.getOutputStream();
		        byte[] buff = new byte[1024];
		        int len = 0;

		        while ((len = in.read(buff, 0, buff.length)) != -1) {
		            out.write(buff, 0, len);
		        }

		        msg.add(SUCCESSDOWNLOAD);
		    }
		    finally
		    {
		        if (in != null)
		        {
		           try {
		                in.close();
		            } catch (IOException e) {
		            	e.printStackTrace();
		            }
		        }

		        if (out != null)
		        {
		            try {
		                out.close();
		            }
		            catch (IOException e)
		            {
		            	e.printStackTrace();
		            }
		        }
		        msg.add(DOWNLOADFAIL);
		    }
	    }
	    //ファイルが存在しない場合
	    else
	    {
	    	msg.add(NOTEXISTDLFILE);
	    }

	    //転送処理
	    final String disPage = "msg.jsp";

	    RequestDispatcher disp = request.getRequestDispatcher(disPage);
	    request.setAttribute("msg", msg);
	    disp.forward(request, response);

	}
}
