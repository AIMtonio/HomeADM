package soporte.consumo.rest;

import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

public class ConsumidorRest<T> {
	private RestTemplate restTemplate ;
	private HttpHeaders headers;
	
	public ConsumidorRest() {
		restTemplate = new RestTemplate();
	}
	
	public void addHeader(String headerName, String headerValue) {
		if(headers == null) {
			headers = new HttpHeaders();
		}
		
		headers.add(headerName, headerValue);
	}
	
	public T consumePost(String url, Object beanRequest, Class<T> beanResponseType) {
		HttpEntity<Object> entity = null;
	    if(headers != null) {
	    	entity = new HttpEntity<Object>(beanRequest, headers);
	    }
	    else {
	    	entity = new HttpEntity<Object>(beanRequest);
	    }
	     
	    T respuesta = restTemplate.postForObject(url, entity, beanResponseType);
	    return respuesta;
	}
	
	public T consumePost(String url, Class<T> beanResponseType) {	
		addHeader("content-type", "application/json");
		
		HttpEntity<String> entity = null;
	    if(headers != null) {
	    	entity = new HttpEntity<String>("{}", headers);
	    }
	    else {
	    	entity = new HttpEntity<String>("{}");
	    }
	     
	    T respuesta = restTemplate.postForObject(url, entity, beanResponseType);
	    return respuesta;
	}
	
	public T consumeGet(String url, Class<T> beanResponseType, Map<String, String> urlVariables) {
		T respuesta = null;
		
	    if(headers != null) {
	    	HttpEntity<Object> entity = new HttpEntity<Object>(headers);
	    	StringBuilder newURL = new StringBuilder(url);
	    	
	    	if(urlVariables != null && !urlVariables.isEmpty()) {
	    		newURL.append("?");
	    		for(String key: urlVariables.keySet()) {
	    			String value = urlVariables.get(key);
	    			newURL.append(key + "=" + value + "&");
	    		}
	    		
	    		url = newURL.toString();
	    		url = url.substring(0, url.length() - 1);
	    	}	    	
	    	
	    	ResponseEntity<T> responseEntity = restTemplate.exchange(url, HttpMethod.GET, entity, beanResponseType);
	    	respuesta = responseEntity.getBody();
	    }
	    else {
	    	respuesta = restTemplate.getForObject(url, beanResponseType, urlVariables);
	    }
	    
	    return respuesta;
	}
}
