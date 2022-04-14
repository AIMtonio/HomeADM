package cliente.servicio;


import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import reporte.ParametrosReporte;
import reporte.Reporte;

import cliente.dao.CuentasBCAMovilDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cliente.bean.CuentasBCAMovilBean;

public class CuentasBCAMovilServicio extends BaseServicio{
	
	//---------- Variables ------------------------------------------------------------------------
	CuentasBCAMovilDAO cuentasBCAMovilDAO = null;
	
	public CuentasBCAMovilServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_Tra_Cue{
		int agregar = 1;
		int actualiza = 2;
	}
	public static interface Enum_Act_Cue{
		int bloquear 	= 1;	// bloquea cuenta PADEMOBILE
		int desbloquear	= 2;	//desbloquea cuenta PADEMOBILE	
		int alta		= 3;	//actualiza el campo UsuarioIDPDM 
		int guardar	= 4;	// Modifica Preguntas Seguridad 
	}
	
	public static interface Enum_Con_Cue{
		int principal   = 1;
		int principalF	= 2;
		int preguntas	= 3;
		int telefonoCta	= 4;
		
	}
	
	public static interface Enum_Lis_Cue{
		int usuarioPDM = 1;
		int gridConRegPDM = 2;
		int usuarioGroupPDM = 3;
		int usuarioTelPDM = 4;
		int gridRegCtaPDM = 5;
		int gridPreSeguridad = 6;
		int listaComboPreSeg = 1;
		int lisPreSeguridad = 7;
	
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, CuentasBCAMovilBean cuentasBCAMovilBean,String listaGrid){		
		MensajeTransaccionBean mensaje = null;		
		switch(tipoTransaccion){		
			case Enum_Tra_Cue.agregar:
				mensaje = cuentasBCAMovilDAO.procesaAltaPDM(cuentasBCAMovilBean);	
			break;	
			case Enum_Tra_Cue.actualiza:
				mensaje = actualizaCuentasBCA(cuentasBCAMovilBean,tipoActualizacion,listaGrid);
			break;			
		}		
		return mensaje;	
	}
	
	public MensajeTransaccionBean actualizaCuentasBCA(CuentasBCAMovilBean cuentasBCAMovilBean,int tipoActualizacion,String listaGrid){
		MensajeTransaccionBean mensaje = null;
		switch(tipoActualizacion){
			case Enum_Act_Cue.bloquear:
				mensaje = cuentasBCAMovilDAO.procesaBloquePDM(cuentasBCAMovilBean,tipoActualizacion);	
			break;
			case Enum_Act_Cue.desbloquear:
				mensaje = cuentasBCAMovilDAO.procesaDesbloqueoPDM(cuentasBCAMovilBean,tipoActualizacion);
			break;	
			case Enum_Act_Cue.guardar:
				ArrayList listaCodigosResp = (ArrayList) creaListaGrid(cuentasBCAMovilBean,listaGrid);
				mensaje = cuentasBCAMovilDAO.guardaPreguntasSeguridad(cuentasBCAMovilBean,listaCodigosResp);
			break;	
		}
		return mensaje;
	}			
		
	// Consulta para las cuentas BCA
	public CuentasBCAMovilBean consulta(int tipoConsulta, CuentasBCAMovilBean cuentasBCAMovilBean){
		CuentasBCAMovilBean cuentasBCAMovilBeanCon= null;
		switch(tipoConsulta){
			case Enum_Con_Cue.principal:
				cuentasBCAMovilBeanCon = cuentasBCAMovilDAO.consultaPrincipal(cuentasBCAMovilBean, tipoConsulta);
			break;
			case Enum_Con_Cue.principalF:
				cuentasBCAMovilBeanCon = cuentasBCAMovilDAO.consultaPrincipal(cuentasBCAMovilBean, tipoConsulta);
			break;
			case Enum_Con_Cue.preguntas:
				cuentasBCAMovilBeanCon = cuentasBCAMovilDAO.consultaPreguntas(cuentasBCAMovilBean, tipoConsulta);
			break;
			case Enum_Con_Cue.telefonoCta:
				cuentasBCAMovilBeanCon = cuentasBCAMovilDAO.consultaTelefonoCelular(cuentasBCAMovilBean, tipoConsulta);
			break;
		
		}
		return cuentasBCAMovilBeanCon;
	}
	
	
	public List lista(int tipoLista, CuentasBCAMovilBean cuentasBCAMovilBean) {
		List listaUsuarioPDM = null;
		switch (tipoLista) {
			case Enum_Lis_Cue.usuarioPDM:
				listaUsuarioPDM = cuentasBCAMovilDAO.listaUsuario(cuentasBCAMovilBean, tipoLista);
			break;				
			case Enum_Lis_Cue.gridConRegPDM:
				listaUsuarioPDM = cuentasBCAMovilDAO.listaGridRegistro(cuentasBCAMovilBean, tipoLista);
			break;	
			case Enum_Lis_Cue.usuarioGroupPDM:
				listaUsuarioPDM = cuentasBCAMovilDAO.listaUsuario(cuentasBCAMovilBean, tipoLista);
			break;	
			case Enum_Lis_Cue.usuarioTelPDM:
				listaUsuarioPDM = cuentasBCAMovilDAO.listaUsuario(cuentasBCAMovilBean, tipoLista);
			break;	
			case Enum_Lis_Cue.gridRegCtaPDM:
				listaUsuarioPDM = cuentasBCAMovilDAO.listaGridRegistro(cuentasBCAMovilBean, tipoLista);
			break;
			case Enum_Lis_Cue.gridPreSeguridad:
				listaUsuarioPDM = cuentasBCAMovilDAO.listaGridPreguntaSeguridad(cuentasBCAMovilBean, tipoLista);
			break;	
			case Enum_Lis_Cue.lisPreSeguridad:
				listaUsuarioPDM = cuentasBCAMovilDAO.listaPreguntaSeguridad(cuentasBCAMovilBean, tipoLista);
			break;
			
		}
		return listaUsuarioPDM;
	}
	
	// Creacion de Lista de Preguntas de Seguridad
	 private List creaListaGrid(CuentasBCAMovilBean bean,String listaGrid){		
		StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaCodigosResp = new ArrayList();
		CuentasBCAMovilBean cuentasBCAMovilBean;
		
		while(tokensBean.hasMoreTokens()){
			cuentasBCAMovilBean = new CuentasBCAMovilBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			cuentasBCAMovilBean.setPreguntaID(tokensCampos[0]);
			cuentasBCAMovilBean.setRespuestas(tokensCampos[1]);
			cuentasBCAMovilBean.setClienteID(bean.getClienteID());
			cuentasBCAMovilBean.setCuentaAhoID(bean.getCuentaAhoID());
			listaCodigosResp.add(cuentasBCAMovilBean);
			
		}
		
		return listaCodigosResp;
	 }
		 
	// Lista para comboBox
	public  Object[] listaCombo(int tipoLista, CuentasBCAMovilBean cuentasBCAMovilBean) {				
		List listaPreguntas = null;
		switch(tipoLista){
			case Enum_Lis_Cue.listaComboPreSeg: 
				listaPreguntas = cuentasBCAMovilDAO.listaPreguntasSeguridad(tipoLista,cuentasBCAMovilBean);
			break;					
		}		
		return listaPreguntas.toArray();		
	}
	
	// Reporte Contrato Medios Electronicos
	public ByteArrayOutputStream contratoMediosElectronicos(CuentasBCAMovilBean cuentasBCAMovilBean, 
		String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		 
		parametrosReporte.agregaParametro("Par_CuentaAhoID", cuentasBCAMovilBean.getCuentaAhoID());
		parametrosReporte.agregaParametro("Par_FechaEmision",(cuentasBCAMovilBean.getFechaEmision()));
		parametrosReporte.agregaParametro("Par_SucursalID",(cuentasBCAMovilBean.getSucursalID()));
		parametrosReporte.agregaParametro("Par_NombreSucursal",(cuentasBCAMovilBean.getNombreSucursal()));
		parametrosReporte.agregaParametro("Par_ClienteID",cuentasBCAMovilBean.getClienteID());

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
		
	//------------------ Geters y Seters ------------------------------------------------------		
	public CuentasBCAMovilDAO getCuentasBCAMovilDAO() {
		return cuentasBCAMovilDAO;
	}

	public void setCuentasBCAMovilDAO(CuentasBCAMovilDAO cuentasBCAMovilDAO) {
		this.cuentasBCAMovilDAO = cuentasBCAMovilDAO;
	}

}
