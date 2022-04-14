package cliente.servicio;


import java.io.ByteArrayOutputStream;
import java.util.List;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
import cliente.bean.ServiFunFoliosBean;
import cliente.bean.ServifunFoliosRepBean;
import cliente.dao.ServiFunFoliosDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class ServiFunFoliosServicio extends BaseServicio{
	ServiFunFoliosDAO serviFunFoliosDAO=null;
	
	public static interface Enum_Tra_serviFunFolios {
		int alta			=1;	
		int modifica 		=2;
		int autorizaRechaza	=3;
	}
	public static interface Enum_Con_serviFunFolios {
		int principal=1;		
	}
	public static interface Enum_Lis_serviFunFolios {
		int principal	=1;	
		int autorizadas =2;
	}
	public static interface Enum_Lis_serviFunFoliosRepExcel {
		int principal	=1;	
	}
	//----Transacciones----
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ServiFunFoliosBean serviFunFoliosBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_serviFunFolios.alta:		
				mensaje = serviFunFoliosDAO.altaRegistro(serviFunFoliosBean);				
				break;	
			case Enum_Tra_serviFunFolios.modifica:		
				mensaje = serviFunFoliosDAO.modificaServiFunFolios(serviFunFoliosBean);				
				break;	
			case Enum_Tra_serviFunFolios.autorizaRechaza:		
				mensaje = serviFunFoliosDAO.autorizaRechazaSERVIFUN(serviFunFoliosBean);				
				break;
		}
		return mensaje;
	}

	
	// ---------- Consulta ----
	public ServiFunFoliosBean consulta(int tipoConsulta, ServiFunFoliosBean serviFunFoliosBean){
		ServiFunFoliosBean serviFunFolios = null;
		switch(tipoConsulta){
			case Enum_Con_serviFunFolios.principal:
				serviFunFolios = serviFunFoliosDAO.consultaPrincipal(serviFunFoliosBean,tipoConsulta);
			break;

		}
		return serviFunFolios;
		
	}

	//---------- Lista  ---------
	public List listaServiFun(int tipoLista, ServiFunFoliosBean serviFunFolios){
		List cuentasAhoLista = null;
		switch (tipoLista) {		    
	        case  Enum_Lis_serviFunFolios.principal:
				cuentasAhoLista = serviFunFoliosDAO.listaPrincipal(serviFunFolios, tipoLista);
	        break;
	        case  Enum_Lis_serviFunFolios.autorizadas:
				cuentasAhoLista = serviFunFoliosDAO.listaPrincipal(serviFunFolios, tipoLista);
	        break;	     
	       
		}
		return cuentasAhoLista;
	}
	
	public List listaReporteSevifunExcel(int tipoLista, ServifunFoliosRepBean serviFunFolios){
		List cuentasAhoLista = null;
		switch (tipoLista) {		    
	        case  Enum_Lis_serviFunFoliosRepExcel.principal:
				cuentasAhoLista = serviFunFoliosDAO.listaReporteServifunExcel(serviFunFolios, tipoLista);
	        break;   	       
		}
		return cuentasAhoLista;
	}
	
	
	
	public ByteArrayOutputStream creaReporteServifunFoliosPDF(ServifunFoliosRepBean servifunFoliosRepBean,String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		 
		parametrosReporte.agregaParametro("Par_FechaInicio",servifunFoliosRepBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",servifunFoliosRepBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(servifunFoliosRepBean.getSucursalID()));		
		parametrosReporte.agregaParametro("Par_NomSucursal",(!servifunFoliosRepBean.getNombreSucursal().isEmpty())? servifunFoliosRepBean.getNombreSucursal():"TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!servifunFoliosRepBean.getNombreInstitucion().isEmpty())?servifunFoliosRepBean.getNombreInstitucion(): "TODOS");
		
		parametrosReporte.agregaParametro("Par_NomUsuario",servifunFoliosRepBean.getClaveUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision",servifunFoliosRepBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_Estatus",servifunFoliosRepBean.getEstatus());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}	
	
	//---------------  Getter y setter----------- 
	public ServiFunFoliosDAO getServiFunFoliosDAO() {
		return serviFunFoliosDAO;
	}

	public void setServiFunFoliosDAO(ServiFunFoliosDAO serviFunFoliosDAO) {
		this.serviFunFoliosDAO = serviFunFoliosDAO;
	}
	
	
}
