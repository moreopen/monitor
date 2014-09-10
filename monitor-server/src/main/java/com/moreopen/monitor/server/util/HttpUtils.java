package com.moreopen.monitor.server.util;

import java.io.File;
import java.net.URI;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.HttpVersion;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.ContentBody;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.params.CoreProtocolPNames;
import org.apache.http.params.HttpParams;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;

@Deprecated
public class HttpUtils {

	protected static  Logger logger = Logger.getLogger(HttpUtils.class);
	/**
	 * 向服务器发送一组变量
	 * 
	 * @param url
	 * @param params
	 * @return
	 * @throws Exception
	 * @throws IllegalStateException
	 * @throws NoSuchElementException
	 * @throws Exception
	 * @throws IllegalStateException
	 * @throws NoSuchElementException
	 */
	public static String postParams(String url, Map<String, String> postParams, String charSet) throws NoSuchElementException, IllegalStateException, Exception {

		HttpClient httpclient = (HttpClient)makeHttpClient();

		HttpPost httppost = new HttpPost(url);

		HttpEntity resEntity = null;

		HttpResponse response = null;

		try {

			List<NameValuePair> qparams = new ArrayList<NameValuePair>();
			for (String o : postParams.keySet()) {
				qparams.add(new BasicNameValuePair(o, postParams.get(o)));
			}
			UrlEncodedFormEntity entity = new UrlEncodedFormEntity(qparams, charSet);
			httppost.setEntity(entity);
			response = httpclient.execute(httppost);
			resEntity = response.getEntity();
			if (response.getStatusLine().getStatusCode() != HttpStatus.SC_OK) {
//				pool.returnObject(httpclient);
				return "";

			}
		} catch (Exception e) {

			logger.error("post resource due to error", e);
		}

		String ret = "";
		if (null != response) {
			logger.debug(response.getStatusLine().toString());
		}

		if (resEntity != null) {
			ret += EntityUtils.toString(resEntity);
		}
		if (resEntity != null) {
			resEntity.consumeContent();
		}
//		pool.returnObject(httpclient);
		return ret;
	}

	/**
	 * 向url发送get请求
	 * 
	 * @param url
	 * @param getParams
	 * @param charSet
	 * @return
	 * @throws Exception
	 * @throws IllegalStateException
	 * @throws NoSuchElementException
	 */
	public static String getParams(String url, Map<String, String> getParams, String charSet) throws NoSuchElementException, IllegalStateException, Exception {
		HttpClient httpclient = (HttpClient) makeHttpClient();

		HttpEntity resEntity = null;

		HttpResponse response = null;

		String params = "";

		boolean and = false;

		if (null != getParams) {
			for (String o : getParams.keySet()) {
				if (and)
					params += "&";
				params += o + "=" + URLEncoder.encode(getParams.get(o),"UTF-8");
				and = true;
			}
			url += "?" + params;
		}

//		HttpGet httpget = new HttpGet(url);
		
		  HttpGet request = new HttpGet();  
          request.setURI(new URI(url));  
		
		
		try {
			response = httpclient.execute(request);
		} catch (Exception e) {
			logger.error("get resource due to error", e);
		}
		resEntity = response.getEntity();

		String ret = "";

		if (null != response) {
			logger.debug(response.getStatusLine().toString());
		}

		if (resEntity != null) {
			ret += EntityUtils.toString(resEntity);
		}
		if (resEntity != null) {
			resEntity.consumeContent();
		}

		// httpclient.getConnectionManager().shutdown();
//		pool.returnObject(httpclient);
		return ret;
	}

	/**
	 * 
	 * @param url
	 *            上传服务器url
	 * @param file
	 *            文件
	 * @param fileParamName
	 *            文件字段名
	 * @param strParams
	 *            其他post的参数
	 * @return
	 * @throws NoSuchElementException
	 * @throws IllegalStateException
	 * @throws Exception
	 */
	public static String postFile(String url, File file, String fileParamName, Map<String, String> strParams) throws NoSuchElementException,
			IllegalStateException, Exception {
		HttpClient httpclient = (HttpClient) makeHttpClient();

		HttpPost httppost = new HttpPost(url);

		MultipartEntity mpEntity = new MultipartEntity();

		
		ContentBody upFile = new FileBody(file);
		mpEntity.addPart(fileParamName, upFile);

		if (null != strParams && !strParams.isEmpty()) {
			Iterator<String> it = strParams.keySet().iterator();
			while (it.hasNext()) {
				String key = (String) it.next();
				String value = strParams.get(key);
				StringBody sb = new StringBody(value);
				mpEntity.addPart(key, sb);
			}
		}

		httppost.setEntity(mpEntity);

		HttpResponse response = httpclient.execute(httppost);

		HttpEntity resEntity = response.getEntity();

		/*
		 * System.out.println(response.getStatusLine()); if (resEntity != null)
		 * { System.out.println(EntityUtils.toString(resEntity)); }
		 */
		String ret = "";

		if (null != response) {
			logger.info(response.getStatusLine().toString());
		}

		if (resEntity != null) {
			ret += EntityUtils.toString(resEntity);
		}

		if (resEntity != null) {
			resEntity.consumeContent();
		}

		// httpclient.getConnectionManager().shutdown();
//		pool.returnObject(httpclient);
		return ret;
	}

	/**
	 * post 一个文件到服务器
	 * 
	 * @param url
	 * @param file
	 *            上传的文件对象。默认文件字段为"uploadfile"
	 * @param strParams
	 *            post附带一些参数
	 * @return
	 * @throws NoSuchElementException
	 * @throws IllegalStateException
	 * @throws Exception
	 */
	public static String postFile(String url, File file, Map<String, String> strParams) throws NoSuchElementException, IllegalStateException, Exception {

		return HttpUtils.postFile(url, file, "uploadfile", strParams);
	}

	/**
	 * 直接发送数据到服务器
	 * 
	 * @param url
	 * @param req
	 * @param charset
	 * @return
	 * @throws Exception
	 * @throws IllegalStateException
	 * @throws NoSuchElementException
	 */
	public static String postString(String url, String req, String charset) throws NoSuchElementException, IllegalStateException, Exception {
//		logger.debug("post url:" + url + " req:" + req);
		HttpClient httpclient = (HttpClient) makeHttpClient();

		HttpPost httppost = new HttpPost(url);

		try {
			StringEntity entity = new StringEntity(req, charset);
			entity.setChunked(true);
			httppost.setEntity(entity);
		} catch (Exception e) {
			logger.error("post resource due to error", e);
		}

		HttpResponse response = httpclient.execute(httppost);

		HttpEntity resEntity = response.getEntity();

		String ret = ""; //
		logger.info(response.getStatusLine().toString());
//		logger.debug(response.getStatusLine().toString());

		if (resEntity != null) {
			ret += EntityUtils.toString(resEntity);
		}
		if (resEntity != null) {
			resEntity.consumeContent();
		}

		// httpclient.getConnectionManager().shutdown();
//		pool.returnObject(httpclient);
		return ret;
	}
	public static Object makeHttpClient() throws Exception {
		HttpParams params = new BasicHttpParams();

		params.setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 20000);

		HttpClient httpclient = new DefaultHttpClient(params);

		httpclient.getParams().setParameter(CoreProtocolPNames.PROTOCOL_VERSION, HttpVersion.HTTP_1_1);

		httpclient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 1000000000);

		return httpclient;
	}
}

