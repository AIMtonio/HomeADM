package soporte;

import general.bean.BaseBean;

import java.io.IOException;

import Exceptions.AuthException;
import Exceptions.GeneralException;
import Services.Csd.SWCsdService;
import Utils.Responses.Csd.CsdResponse;

public class SmarterWebWS  extends BaseBean{
	private String tokenSW;
	private String urlSW;
	public boolean error;
	
	public SmarterWebWS(String urlSW, String tokenSW) {
		this.urlSW = urlSW;
		this.tokenSW = tokenSW;
		this.error = false;
	}
	
	public String enviarCertificadoSW(String archivoKey,String archivoCer,String clave){
		SWCsdService app = new SWCsdService(this.tokenSW, this.urlSW);
		CsdResponse response = null;
		try {
			response = (CsdResponse) app.UploadMyCsd(archivoCer, archivoKey, clave, "stamp", true);
		}catch (AuthException e) {					
			e.printStackTrace();			
		} catch (GeneralException e) {			
			e.printStackTrace();					 
		}catch (IOException e) {			
			e.printStackTrace();					 
		}
		return response.Status;
	}
}
