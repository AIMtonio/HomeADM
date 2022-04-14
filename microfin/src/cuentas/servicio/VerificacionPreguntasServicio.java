package cuentas.servicio;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.StringTokenizer;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cuentas.bean.VerificacionPreguntasBean;
import cuentas.dao.VerificacionPreguntasDAO;

public class VerificacionPreguntasServicio extends BaseServicio{
	
	VerificacionPreguntasDAO verificacionPreguntasDAO = null;
	
	public VerificacionPreguntasServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	// Transaccion de Verificacion de Preguntas
	public static interface Enum_Tra_VerificaPreguntas{
		int validar = 1;
		int enviar = 2;
		int validaSeguimiento = 3;
		int enviarCometarios = 4;
		int cancelarFolio = 5;
		int finalizarFolio = 6;
	}
		
	public static interface Enum_Lis_VerificaPreguntas{
		int lisPreSeguridad = 1;
		int listaComboTipSoporte = 2;
		int listaFolios = 3;
	}
	
	
	public static interface Enum_Con_SeguimientoFolioJPMovil{
		int consultaFolioSeguimiento = 1;
	}
	
	public static interface Enum_Lis_SeguimientoFolioJPMovil{
		int listaFolioSeguimiento = 1;
		int listaComentarios = 2;
	}
	// Transacciones Verificacion de Preguntas
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,VerificacionPreguntasBean verificacionPreguntasBean,String listaGrid) { 
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_VerificaPreguntas.validar:
				ArrayList listaCodigosResp = (ArrayList) creaListaGrid(verificacionPreguntasBean,listaGrid);
				mensaje = verificacionPreguntasDAO.validaPreguntasSeguridad(verificacionPreguntasBean,listaCodigosResp);
				if(mensaje.getCampoGenerico()!=null){
					MensajeTransaccionBean mensajeFolio = verificacionPreguntasDAO.altaFolioSeguimiento(verificacionPreguntasBean);
					String mensajeStr = "";
					
					if(mensajeFolio.getNumero()==0){
						mensajeStr = mensaje.getDescripcion()+"<br> Se créo el "+mensajeFolio.getDescripcion()+" Para el Seguimiento";
						mensaje.setDescripcion(mensajeStr);
					}else{
						mensajeStr = mensaje.getDescripcion()+"<br> No se puedo Crear el Folio de Seguimiento: <br>"+mensajeFolio.getDescripcion();
						mensaje.setDescripcion(mensajeStr);
					}
				}
				break;
			case Enum_Tra_VerificaPreguntas.enviar:
				ArrayList listaCodigosRespEnvio = (ArrayList) creaListaGrid(verificacionPreguntasBean,listaGrid);
				mensaje = verificacionPreguntasDAO.enviarPreguntasSeguridad(verificacionPreguntasBean,listaCodigosRespEnvio);
				break;
			case Enum_Tra_VerificaPreguntas.validaSeguimiento:
				ArrayList listaCodigosRespSeg = (ArrayList) creaListaGrid(verificacionPreguntasBean,listaGrid);
				mensaje = verificacionPreguntasDAO.validaPreguntasSeguridad(verificacionPreguntasBean, listaCodigosRespSeg);
				break;
			case Enum_Tra_VerificaPreguntas.enviarCometarios:
				mensaje = verificacionPreguntasDAO.altaCometarioFolioSeguimiento(verificacionPreguntasBean);
				break;
			case Enum_Tra_VerificaPreguntas.cancelarFolio:
				mensaje = verificacionPreguntasDAO.modificaFolioSeguimiento(verificacionPreguntasBean, Enum_Tra_VerificaPreguntas.cancelarFolio);
				break;
			case Enum_Tra_VerificaPreguntas.finalizarFolio:
				mensaje = verificacionPreguntasDAO.modificaFolioSeguimiento(verificacionPreguntasBean, Enum_Tra_VerificaPreguntas.finalizarFolio);
				break;
		}
		return mensaje;
	}
	
	// Creacion de Lista de Preguntas de Seguridad
	 private List creaListaGrid(VerificacionPreguntasBean bean,String listaGrid){		
		StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaCodigosResp = new ArrayList();
		VerificacionPreguntasBean cuentasBCAMovilBean;
		
		while(tokensBean.hasMoreTokens()){
			cuentasBCAMovilBean = new VerificacionPreguntasBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			cuentasBCAMovilBean.setPreguntaID(tokensCampos[0]);
			cuentasBCAMovilBean.setRespuestas(tokensCampos[1]);
			cuentasBCAMovilBean.setClienteID(bean.getClienteID());
			cuentasBCAMovilBean.setNumeroTelefono(bean.getNumeroTelefono());
			cuentasBCAMovilBean.setTipoSoporteID(bean.getTipoSoporteID());
			cuentasBCAMovilBean.setUsuarioID(bean.getUsuarioID());
			cuentasBCAMovilBean.setComentarios(bean.getComentarios());
			
			listaCodigosResp.add(cuentasBCAMovilBean);
			
		}
		
		return listaCodigosResp;
	 }
			 
		 
	// Lista de Preguntas de Seguridad
	public List lista(int tipoLista, VerificacionPreguntasBean verificacionPreguntasBean) {
		List listaPreguntas = null;
		switch (tipoLista) {
			case Enum_Lis_VerificaPreguntas.lisPreSeguridad:
				listaPreguntas = verificacionPreguntasDAO.listaPreguntaSeguridad(verificacionPreguntasBean, tipoLista);
			break;
			
		}
		return listaPreguntas;
	}
			
	// Lista para comboBox Tipos de Soporte
	public  Object[] listaCombo(int tipoLista, VerificacionPreguntasBean verificacionPreguntasBean) {				
		List listaTiposSoporte = null;
		switch(tipoLista){
			case Enum_Lis_VerificaPreguntas.listaComboTipSoporte: 
				listaTiposSoporte = verificacionPreguntasDAO.listaTiposSoporte(tipoLista,verificacionPreguntasBean);
			break;					
		}		
		return listaTiposSoporte.toArray();		
	}
	
	public List<VerificacionPreguntasBean> listaFolio(int tipoLista, VerificacionPreguntasBean verificacionPreguntasBean){
		List<VerificacionPreguntasBean>listaFoliosSeguimiento = null;
		switch(tipoLista){
			case Enum_Lis_SeguimientoFolioJPMovil.listaFolioSeguimiento:
				listaFoliosSeguimiento = verificacionPreguntasDAO.listaFolioSeguimiento(verificacionPreguntasBean, tipoLista);
				break;
			case Enum_Lis_SeguimientoFolioJPMovil.listaComentarios:
				listaFoliosSeguimiento = verificacionPreguntasDAO.listaComentaFolio(verificacionPreguntasBean, tipoLista);
				Collections.reverse(listaFoliosSeguimiento);
		}
		return listaFoliosSeguimiento;
	}
	
	public VerificacionPreguntasBean consultaFolio(int tipoConsulta, VerificacionPreguntasBean verificacionPreguntasBean){
		VerificacionPreguntasBean veriPreguntasBean = null;
		switch(tipoConsulta){
			case Enum_Con_SeguimientoFolioJPMovil.consultaFolioSeguimiento:
				veriPreguntasBean = verificacionPreguntasDAO.consultaFolioSeguimiento(verificacionPreguntasBean, tipoConsulta);
				break;
		}
		return veriPreguntasBean;
	}
	
	
	// ================ GETTER Y SETTER ============== //
	
	public VerificacionPreguntasDAO getVerificacionPreguntasDAO() {
		return verificacionPreguntasDAO;
	}

	public void setVerificacionPreguntasDAO(
			VerificacionPreguntasDAO verificacionPreguntasDAO) {
		this.verificacionPreguntasDAO = verificacionPreguntasDAO;
	}
}
