package herramientas;

import org.apache.log4j.Logger;

import bsh.util.Util;

import java.lang.reflect.*;

import java_cup.internal_error;

import soporte.bean.UsuarioBean;

import general.bean.BaseBean;
import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;

public class SistemaLogging {
	
	 static ParametrosSesionBean parametrosSesionBean = null;
 	 //static ParametrosAuditoriaBean parametrosAuditoriaBean = null;
 	
 	 
 	public static void escribeLog(String programa,
 								  ParametrosAuditoriaBean parametrosAuditoriaBean,
 								  Object bean,
 								  Class clasePadre, String ClaseBean) throws Exception {
 	/*	public static void escribeLog(String programa,
				  ParametrosAuditoriaBean parametrosAuditoriaBean,
				  BaseBean bean,
				  Class clasePadre) throws Exception {*/
 		
 		//try {
	
 		programa="Programa:"+programa;
 		Logger log = Logger.getLogger(clasePadre);
 		String usuario = " User:"+parametrosSesionBean.getClaveUsuario();
 		String transaccion="No. Transaccion:"+String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion());
 		//Class baseBean = Class.forName("general.bean.ParametrosSesionBean");
 		//Class baseBean = Class.forName("soporte.bean.UsuarioBean");
 		
 		Class baseBean = Class.forName(ClaseBean);  log.info("name de la claseBean"+ClaseBean);
 		Field[] baseFields = baseBean.getFields();log.info("tamaño de baseFields1 "+baseFields.length);
 		Method metodoGet = null; 		
 		Field campo;
 		Object campoValor;
 		String cadenaAtributos = "Atributos[";
 		
 		for(int i =0; i<baseFields.length;i++){
 			campo = baseFields[i];
 			String nombreCampo = campo.getName();
 			
 			metodoGet = baseBean.getMethod("get" + nombreCampo.substring(0, 1).toUpperCase() + nombreCampo.substring(1, nombreCampo.length())  , null); 			
 			campoValor = metodoGet.invoke(bean, null);
 			if(campoValor!=null){
 				cadenaAtributos = cadenaAtributos + nombreCampo + ":" + campoValor.toString() + ";";
 			}
 		}
 		
 		cadenaAtributos=cadenaAtributos.substring(0,cadenaAtributos.length()-1);
		cadenaAtributos=cadenaAtributos+"]";
 		 		
		String datos = usuario+","+programa+","+transaccion+","+cadenaAtributos;
		log.info(datos);
 	}
 	 

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	
	

}
