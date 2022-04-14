package cliente.servicio;

import java.util.List;
import java.util.ArrayList;
import java.util.StringTokenizer;
import java.io.ByteArrayOutputStream;
import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.AnticipoFacturaBean;
import tesoreria.servicio.AnticipoFacturaServicio.Enum_Lis_AnticipoFactura;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import cliente.bean.ClientesCancelaBean;
import cliente.dao.ClientesCancelaDAO;


public class ClientesCancelaServicio extends BaseServicio {
	
	// Variables 
	ClientesCancelaDAO clientesCancelaDAO = null;
		
	    // tipo de consulta
	public static interface Enum_Tra_ClientesCancela{
		int alta		= 1;
		int actualiza	= 2;
		int altaBeneficios	= 3;
	}		
	
	public static interface Enum_Act_ClientesCancela{
		int cancela = 1;
	}		
	
	public static interface Enum_Con_ClientesCancela { 
		int principal	= 1;	// consulta por folio de cancelacion 
		int cliente		= 2;	// consulta por un cliente en especifico	
		int proteccion	= 3;	// consulta por un cliente en especifico y que sea del area de proteccion
		int autorizaprotec	= 4; // Consulta autorizadas por protecciones
		int pagoCancelacionSoc = 5; // Consulta cantidad a recibir en pago cancelacion socio ventanilla
		int folioCancela       = 6;
	}
	public static interface Enum_Lis_ClientesCancela {
		int principal	= 1;
		int autorizadas	= 2;
		int autorizaProtec	= 3;
		int principalProtecAhor = 4;
	}
	
	public static interface Enum_Lis_DistribucionBeneficiosCta {
		int beneCuentas	= 3;  //Lista de Beneficiarios de Cuentas
	}
	
	public static interface Enum_Lis_DistribucionBeneficiosInv {
		int beneInversion	= 2;  //Lista de Beneficiarios de Inversion
	}
	
	public ClientesCancelaServicio() {
		super();
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, ClientesCancelaBean clientesCancelaBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_ClientesCancela.alta:
			mensaje = altaClientesCancela(clientesCancelaBean);	
			break;
		case Enum_Tra_ClientesCancela.actualiza:
			mensaje = actualizaClientesCancela(clientesCancelaBean,tipoActualizacion);
			break;
		case Enum_Tra_ClientesCancela.altaBeneficios:
			mensaje = altaDistribucionBeneficios(clientesCancelaBean);	
			break;
		}
		return mensaje;
	}
				
	public MensajeTransaccionBean altaClientesCancela(ClientesCancelaBean clientesCancelaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = clientesCancelaDAO.procesoCancelAlta(clientesCancelaBean);		
		return mensaje;
	}

	public MensajeTransaccionBean actualizaClientesCancela(ClientesCancelaBean clientesCancelaBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = clientesCancelaDAO.actualizacion(clientesCancelaBean, tipoActualizacion);		
		return mensaje;
	}
	
		// Alta de distribucion de beneficios
		public MensajeTransaccionBean altaDistribucionBeneficios(ClientesCancelaBean clientesCancelaBean){
			MensajeTransaccionBean mensaje = null;
			ArrayList listaDistribucionBeneficios = (ArrayList) creaListaDistribucionBeneficios(clientesCancelaBean.getListaDistribucionBen());
			mensaje = clientesCancelaDAO.aplicaDistribucionBeneficios(clientesCancelaBean,listaDistribucionBeneficios);

			return mensaje;
		}
		
		//Lista de distribucion de beneficios
		private List creaListaDistribucionBeneficios(String listaDistribucionBen){
			StringTokenizer tokensBean = new StringTokenizer(listaDistribucionBen, ",");
			
			String stringCampos;
			String tokensCampos[];
			ArrayList listaPagos = new ArrayList();
			ClientesCancelaBean clientesCancelaBean;
			
			while(tokensBean.hasMoreTokens()){
				clientesCancelaBean = new ClientesCancelaBean();
				stringCampos = tokensBean.nextToken();
				tokensCampos = herramientas.Utileria.divideString(stringCampos, "-");
		
					clientesCancelaBean.setNombreBeneficiario(tokensCampos[1]);
					clientesCancelaBean.setPorcentaje(tokensCampos[2]);
					clientesCancelaBean.setCantidadRecibir(tokensCampos[3]);
					clientesCancelaBean.setCuentaAhoID(tokensCampos[4]);
					clientesCancelaBean.setPersonaID(tokensCampos[5]);
					clientesCancelaBean.setClienteBenID(tokensCampos[6]);
					clientesCancelaBean.setParentescoID(tokensCampos[7]);
					listaPagos.add(clientesCancelaBean);
				
			}			
			return listaPagos;
		}
	
	public ClientesCancelaBean consulta(int tipoConsulta,ClientesCancelaBean clientesPROF){
		ClientesCancelaBean clientesCancelaBean = null;
		switch (tipoConsulta) {
			case Enum_Con_ClientesCancela.principal:		
				clientesCancelaBean = clientesCancelaDAO.consultaPrincipal(clientesPROF, Enum_Con_ClientesCancela.principal);				
				break;				
			case Enum_Con_ClientesCancela.cliente:		
				clientesCancelaBean = clientesCancelaDAO.consultaCliente(clientesPROF, Enum_Con_ClientesCancela.cliente);				
				break;	
			case Enum_Con_ClientesCancela.proteccion:		
				clientesCancelaBean = clientesCancelaDAO.consultaProtecciones(clientesPROF, Enum_Con_ClientesCancela.proteccion);				
				break;
			case Enum_Con_ClientesCancela.autorizaprotec:		
				clientesCancelaBean = clientesCancelaDAO.consultaProteccionesAutorizadas(clientesPROF, Enum_Con_ClientesCancela.autorizaprotec);				
				break;
			case Enum_Con_ClientesCancela.folioCancela:		
			clientesCancelaBean = clientesCancelaDAO.consultaFolioCancela(clientesPROF, Enum_Con_ClientesCancela.folioCancela);				
			break;	
		}
		return clientesCancelaBean;
	}		
	
	/* =========  Reporte PDF de cancelacion cliente  =========== */
	public ByteArrayOutputStream reporteClientesCancela(int tipoReporte, ClientesCancelaBean bean , String nomReporte) throws Exception{		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_FechaInicio",bean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",bean.getFechaFin());
		parametrosReporte.agregaParametro("Par_ClienteID",bean.getClienteID() );
		parametrosReporte.agregaParametro("Par_SucursalID",bean.getSucursalID() );
		parametrosReporte.agregaParametro("Par_NombreCliente", bean.getNombreCliente());
		parametrosReporte.agregaParametro("Par_SucursalCliente", bean.getSucursalCliente());
		
		parametrosReporte.agregaParametro("Par_NumRep",tipoReporte);
		
		parametrosReporte.agregaParametro("Par_NombreInstitucion", bean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema",Utileria.convierteFecha(bean.getFechaSistema()));
		parametrosReporte.agregaParametro("Par_Usuario",bean.getNombreUsuario());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}
	
	/* =========  Reporte PDF de Solicitud Cancelacion Cliente menor y mayor=========== */
	public ByteArrayOutputStream reporteSolicitudClientesCancela(int tipoReporte, ClientesCancelaBean bean , String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_ClienteID",bean.getClienteID() );
		parametrosReporte.agregaParametro("Par_NumRep",tipoReporte);
		parametrosReporte.agregaParametro("Par_NombreInstitucion", bean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema",bean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_SucursalID",bean.getSucursalID());
		parametrosReporte.agregaParametro("Par_ClienteCancelaID",bean.getClienteCancelaID());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}
	
	/* =========  Reporte PDF de Solicitud Cancelacion Cliente / Cliente Menor =========== */
	public ByteArrayOutputStream reportePagoSolicitudClientesCancela(int tipoReporte, ClientesCancelaBean bean , String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_ClienteID",bean.getClienteID() );
		parametrosReporte.agregaParametro("Par_NomIn", bean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_NumSucursal",bean.getSucursalID());
		parametrosReporte.agregaParametro("Par_NomSucursal",bean.getSucursalDes());
		parametrosReporte.agregaParametro("Par_NomUsuario",bean.getUsuarioSesion());
		parametrosReporte.agregaParametro("Par_ClienteCancelaID",bean.getClienteCancelaID());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
		
	
	
	public List lista(int tipoLista, ClientesCancelaBean clientesCancelaBean){
		List clientesCancela = null;
		switch (tipoLista) {
	        case  Enum_Lis_ClientesCancela.principal:
	        	clientesCancela = clientesCancelaDAO.listaPrincipal(clientesCancelaBean, tipoLista);
	        break;
	        case  Enum_Lis_ClientesCancela.autorizadas:
	        	clientesCancela = clientesCancelaDAO.listaAutorizadas(clientesCancelaBean, tipoLista);
	        break;
	        case  Enum_Lis_ClientesCancela.autorizaProtec:
	        	clientesCancela = clientesCancelaDAO.listaAutorizadasProteccion(clientesCancelaBean, tipoLista);
	        break;
	        case  Enum_Lis_ClientesCancela.principalProtecAhor:
	        	clientesCancela = clientesCancelaDAO.listaPrincipal(clientesCancelaBean, tipoLista);
	        break;
	        
		}
		return clientesCancela;
	}
	
	public List listaBeneficiariosCta(int tipoLista, ClientesCancelaBean clientesCancelaBean){		
		List beneficiariosCta = null;
		switch (tipoLista) {	
			case Enum_Lis_DistribucionBeneficiosCta.beneCuentas:		
				beneficiariosCta = clientesCancelaDAO.listaGridBeneficiariosCta(clientesCancelaBean, tipoLista);			
				break;			 
		}				
		return beneficiariosCta;
	}
	
	public List listaBeneficiariosInv(int tipoLista, ClientesCancelaBean clientesCancelaBean){		
		List beneficiariosInv = null;
		switch (tipoLista) {	
			case Enum_Lis_DistribucionBeneficiosInv.beneInversion:		
				beneficiariosInv = clientesCancelaDAO.listaGridBeneficiariosInv(clientesCancelaBean, tipoLista);			
				break;			 
		}				
		return beneficiariosInv;
	}
	//------------------ Getters y Setters ------------------------------------------------------	
	public void setClientesCancelaDAO(ClientesCancelaDAO clientesCancelaDAO) {
		this.clientesCancelaDAO = clientesCancelaDAO;
	}

	public ClientesCancelaDAO getClientesCancelaDAO() {
		return clientesCancelaDAO;
	}
				
}

