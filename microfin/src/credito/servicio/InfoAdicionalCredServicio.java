package credito.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import bsh.util.Util;

import WSVSNATGAS.request.CreacionCredBeanRequest;
import WSVSNATGAS.request.SigninBeanRequest;
import WSVSNATGAS.response.CreacionCredBeanResponse;
import WSVSNATGAS.response.SigninBeanResponse;

import soporte.serviciosrest.ConexionWSRest;

import credito.bean.InfoAdicionalCredBean;
import credito.dao.InfoAdicionalCredDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Constantes.logger;
import herramientas.Utileria;

public class InfoAdicionalCredServicio extends BaseServicio{
	InfoAdicionalCredDAO infoAdicionalCredDAO = null;
	ConexionWSRest conexionWSRest = null;
	
	String token = null;
	
	public InfoAdicionalCredServicio(){
		super();
	}
	
	public static interface Enum_Tra_Relaciones {
		int alta = 1;
	}
	
	public static interface Enum_Lis_Relaciones {
		int relacionesCred = 1;
	}	
	
	public static interface Enum_Con_Relaciones {
		int relacion = 1;
		int consumoWS = 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, InfoAdicionalCredBean relacionCred, 
			String lisPlacas, String lisGnv, String lisVin, String lisEst){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Relaciones.alta:		
				mensaje = altaRelacionCredito(relacionCred, lisPlacas, lisGnv, lisVin, lisEst);
				consulta2(relacionCred, 2);
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaRelacionCredito(InfoAdicionalCredBean relacionCred,
			String lisPlacas, String lisGnv, String lisVin, String lisEst){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaRelacionesCred = (ArrayList) creaListaRelacionCred(relacionCred, lisPlacas, lisGnv, lisVin, lisEst);
		mensaje = infoAdicionalCredDAO.grabaListaRelaciones(relacionCred, listaRelacionesCred );
		return mensaje;
	}
	
	private List creaListaRelacionCred(InfoAdicionalCredBean relacionCred, 
			String lisPlacas, String lisGnv, String lisVin, String lisEst){
		StringTokenizer tokensPlaca = new StringTokenizer(lisPlacas, ",");
		StringTokenizer tokensVin = new StringTokenizer(lisVin, ",");
		StringTokenizer tokensGnv = new StringTokenizer(lisGnv, ",");
		StringTokenizer tokensEst = new StringTokenizer(lisEst, ",");
		ArrayList listaRel = new ArrayList();
		
		InfoAdicionalCredBean relacion;
		
		String lisPlaca[]	= new String[tokensPlaca.countTokens()];
		String lisVinV[]	= new String[tokensVin.countTokens()];	
		String lisGnvV[]	= new String[tokensGnv.countTokens()];	
		String lisEsta[]	= new String[tokensEst.countTokens()];
		
		int i=0;
		while(tokensPlaca.hasMoreTokens()){
			lisPlaca[i] = String.valueOf(tokensPlaca.nextToken());
			i++;
		}
		i = 0;
		while(tokensVin.hasMoreTokens()){
			lisVinV[i] = String.valueOf(tokensVin.nextToken());
			i++;
		}
		i=0;
		while(tokensGnv.hasMoreTokens()){
			lisGnvV[i] = String.valueOf(tokensGnv.nextToken());
			i++;
		}
		i = 0;
		while(tokensEst.hasMoreTokens()){
			lisEsta[i] = String.valueOf(tokensEst.nextToken());
			i++;
		}
		
		for(int contador=0; contador < lisPlaca.length; contador++){
			relacion = new InfoAdicionalCredBean();;
			relacion.setCreditoID(relacionCred.getCreditoID());
			relacion.setPlaca(String.valueOf(lisPlaca[contador]));
			relacion.setVin(String.valueOf(lisVinV[contador]));
			relacion.setGnv(String.valueOf(lisGnvV[contador]));
			relacion.setEstatusWS(String.valueOf(lisEsta[contador]));
			listaRel.add(relacion);
			
			int numero = 0;
		}
		return listaRel;
	}
	
	public InfoAdicionalCredBean consulta(int tipoConsulta, InfoAdicionalCredBean bean){						
		InfoAdicionalCredBean relacion = null;
		switch (tipoConsulta) {
			case Enum_Con_Relaciones.relacion:
				relacion = infoAdicionalCredDAO.consultaRelacion(bean, tipoConsulta);				
				break;
		}
		return relacion;
	}
	
	public List lista(int tipoLista, InfoAdicionalCredBean relacionCred){		
		List listaRelaciones = null;
		switch (tipoLista) {
			case Enum_Lis_Relaciones.relacionesCred:
				listaRelaciones = infoAdicionalCredDAO.listaRelacionesCredito(relacionCred,tipoLista);
			break;
		}
		return listaRelaciones;
	}
	
	public Object consulta2(InfoAdicionalCredBean relacionCred, int tipoConsulta){
		MensajeTransaccionBean mensaje = null;
		int numero = 0;
		switch (tipoConsulta) { 
			case Enum_Con_Relaciones.consumoWS:
				mensaje = consumoToken(relacionCred);
				numero = mensaje.getNumero();
			break;
		}
		return numero;
	}
	
	public MensajeTransaccionBean consumoToken(InfoAdicionalCredBean relacionCred) {
		MensajeTransaccionBean mensaje = null;
		InfoAdicionalCredBean parametroConexionBean = new InfoAdicionalCredBean() ;
		InfoAdicionalCredBean endPointWS = new InfoAdicionalCredBean();
		parametroConexionBean = infoAdicionalCredDAO.consultaParamConexion(parametroConexionBean, 2);
		SigninBeanRequest signinBeanRequest = new SigninBeanRequest();
		SigninBeanResponse signinBeanResponse = new SigninBeanResponse();
			
		try {
			signinBeanRequest.setUser(parametroConexionBean.getUsuarioWSNG());
			signinBeanRequest.setPassword(parametroConexionBean.getPasswordWSNG());
			
			endPointWS.setLlaveParametro("SigninWSNG");
			endPointWS = infoAdicionalCredDAO.consultaEndPoint(endPointWS, 3);
			conexionWSRest = new ConexionWSRest(parametroConexionBean.getUrlWSNG()+endPointWS.getValorParametro());
			conexionWSRest.addHeader("Authorization", parametroConexionBean.getUsuarioWSNG());
			
			signinBeanResponse = (SigninBeanResponse) conexionWSRest.peticionPOST(signinBeanRequest, SigninBeanResponse.class, parametroConexionBean.getTimeOutConWS(), Constantes.logger.SAFI);
			
			if(signinBeanResponse.getToken() == null) {
				if(signinBeanResponse.getError() != null){
					throw new Exception(signinBeanResponse.getError());
				} else {
					throw new Exception("Error al consumir Web Services del Signin para la obtención del Token");		
				}
			}			
			
			//Aqui hay que rescatar el token
			token = signinBeanResponse.getToken();
			mensaje = consumoCreacionCred(relacionCred);

		}catch(Exception e) {
			e.printStackTrace();
			
			if(mensaje == null){
				mensaje = new MensajeTransaccionBean();
			}
			mensaje.setNumero(900);
			mensaje.setDescripcion("¡Ocurrio un error!<br>Estimado usuario, por el momento el servicio no esta disponible, intente mas tarde.");
			mensaje.setNombreControl("consumirSignin");
		}
		String descripcion = mensaje.getDescripcion(); 
		MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
		if(mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ){
			descripcion = descripcion + " " + mensajeTransaccionBean.getDescripcion();
			mensaje.setDescripcion(descripcion);
		}
		return mensaje;	
	}
	
	public MensajeTransaccionBean consumoCreacionCred(InfoAdicionalCredBean relacionCred) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		InfoAdicionalCredBean parametroConexionBean = new InfoAdicionalCredBean() ;
		InfoAdicionalCredBean endPointWS = new InfoAdicionalCredBean();
		parametroConexionBean = infoAdicionalCredDAO.consultaParamConexion(parametroConexionBean, 2);
		List<InfoAdicionalCredBean> datos = new ArrayList();
		datos = infoAdicionalCredDAO.consultaDatos(relacionCred, 2);
		CreacionCredBeanRequest creacionCredBeanRequest = new CreacionCredBeanRequest();
		CreacionCredBeanResponse creacionCredBeanResponse = new CreacionCredBeanResponse();
		
		for(InfoAdicionalCredBean dato : datos ){
			try {
				creacionCredBeanRequest.setPlaca(dato.getPlaca());
				creacionCredBeanRequest.setNumero_credito(dato.getCreditoID());
				creacionCredBeanRequest.setRecaudo(dato.getRecaudo());
				creacionCredBeanRequest.setPlazo(dato.getPlazo());
				creacionCredBeanRequest.setVin(dato.getVin());
			
				endPointWS.setLlaveParametro("CreaCredWSNG");
				endPointWS = infoAdicionalCredDAO.consultaEndPoint(endPointWS, 4);
				conexionWSRest = new ConexionWSRest(parametroConexionBean.getUrlWSNG()+endPointWS.getValorParametro());
				conexionWSRest.addHeader("Authorization", "Bearer " +token);
	
				creacionCredBeanResponse = (CreacionCredBeanResponse) conexionWSRest.peticionPOST(creacionCredBeanRequest, CreacionCredBeanResponse.class, parametroConexionBean.getTimeOutConWS(), Constantes.logger.SAFI);

				String Placa = dato.getPlaca();
				int Credito = Utileria.convierteEntero(dato.getCreditoID());
				double Recaudo = dato.getRecaudo();
				double Plazo  = dato.getPlazo();
				String Vin = dato.getVin();
				
				if(creacionCredBeanResponse.getSuccess() != null) {
					mensaje = infoAdicionalCredDAO.modificaEst(Placa, Credito, Recaudo, Plazo, Vin, 1);
					mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(1);
					mensaje.setDescripcion(creacionCredBeanResponse.getSuccess());
				} else {
					if(creacionCredBeanResponse.getError() != null){
						mensaje = infoAdicionalCredDAO.modificaEst(Placa, Credito, Recaudo, Plazo, Vin, 2);
						mensaje = new MensajeTransaccionBean();
						mensaje.setNumero(0);
						mensaje.setDescripcion(creacionCredBeanResponse.getError());
					} else {
						mensaje = infoAdicionalCredDAO.modificaEst(Placa, Credito, Recaudo, Plazo, Vin, 3);
						mensaje = new MensajeTransaccionBean();
						mensaje.setNumero(0);
						mensaje.setDescripcion("Error al consumir Web Services de la Creación del Crédito para la obtención del Token");
					}
				}
			}catch(Exception e) {
				e.printStackTrace();
				
				if(mensaje == null){
					mensaje = new MensajeTransaccionBean();
				}
				mensaje.setNumero(900);
				mensaje.setDescripcion("¡Ocurrio un error!<br>Estimado usuario, por el momento el servicio no esta disponible, intente mas tarde.");
				mensaje.setNombreControl("consumirCreacionCredito");
			}
		}
		String descripcion = mensaje.getDescripcion(); 
		MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
		if(mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ){
			descripcion = descripcion + " " + mensajeTransaccionBean.getDescripcion();
			mensaje.setDescripcion(descripcion);
		}
		return mensaje;
	}
	
	public InfoAdicionalCredDAO getInfoAdicionalCredDAO() {
		return infoAdicionalCredDAO;
	}

	public void setInfoAdicionalCredDAO(InfoAdicionalCredDAO infoAdicionalCredDAO) {
		this.infoAdicionalCredDAO = infoAdicionalCredDAO;
	}
}