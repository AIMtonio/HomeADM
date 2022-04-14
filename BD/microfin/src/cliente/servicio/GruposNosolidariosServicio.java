package cliente.servicio;
 
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import contabilidad.bean.ReporteBalanzaContableBean;
import contabilidad.servicio.ReportesContablesServicio.Enum_Lis_ReportesContables;
import operacionesPDA.beanWS.request.SP_PDA_Segmentos_DescargaRequest;
import operacionesPDA.beanWS.request.SP_PDA_Socios_DescargaRequest;
import operacionesPDA.beanWS.response.SP_PDA_Segmentos_DescargaResponse;
import operacionesPDA.beanWS.response.SP_PDA_Socios_DescargaResponse;
import reporte.ParametrosReporte;
import reporte.Reporte;
import cliente.bean.ClienteBean;
import cliente.bean.GruposNosolidariosBean;
import cliente.dao.GruposNosolidariosDAO;
import cliente.servicio.ClienteServicio.Enum_Lis_Cliente;

public class GruposNosolidariosServicio extends BaseServicio{

	public GruposNosolidariosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	GruposNosolidariosDAO gruposNosolidariosDAO = null;
	
	public static interface Enum_Tra_Grupos {
		int alta = 1;
		int modifica = 2;
	}
	public static interface Enum_Con_Grupos {
		int principal = 1;
	}
	
	public static interface Enum_Lis_Grupos {
		int principal = 1;
		int gruposActivo	=2;   // lista los grupos no solidarios que se encuentren activos
		int clientesGpo	=3;	 // lista los socios que pertenezcan a un grupo no solidario
	}
	public static interface Enum_Lista_Rep {
		int principal = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,GruposNosolidariosBean gruposNosolidariosBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Grupos.alta:
				mensaje = gruposNosolidariosDAO.altaGrupo(gruposNosolidariosBean);
				break;
			case Enum_Tra_Grupos.modifica:
				mensaje = gruposNosolidariosDAO.modificaGrupo(gruposNosolidariosBean);
				break;
			
		}
		return mensaje;
	}
	public GruposNosolidariosBean consulta(int tipoConsulta, GruposNosolidariosBean gruposNosolidariosBean){

		GruposNosolidariosBean gruposNosolidarios = null;
		switch (tipoConsulta) { 
			case Enum_Con_Grupos.principal:				
				gruposNosolidarios = gruposNosolidariosDAO.consultaGrupo(gruposNosolidariosBean, tipoConsulta);
			break;
			
		}
		
		return gruposNosolidarios;
	}
	public List lista(int tipoLista, GruposNosolidariosBean gruposNosolidariosBean){		
		List listaGrupos = null;
		switch (tipoLista) {
			case Enum_Lis_Grupos.principal:		
				listaGrupos = gruposNosolidariosDAO.listaPrincipal(gruposNosolidariosBean, tipoLista);				
				break;
		}
		return listaGrupos;
	}
	
	/* lista segmentos (grupos no solidarios) para WS */
	public SP_PDA_Segmentos_DescargaResponse listaGruposWS(SP_PDA_Segmentos_DescargaRequest bean){
		SP_PDA_Segmentos_DescargaResponse respuestaLista = new SP_PDA_Segmentos_DescargaResponse();			
		List listaGrupos;
		GruposNosolidariosBean grupo;
		
		listaGrupos = gruposNosolidariosDAO.listaGruposWS(bean,Enum_Lis_Grupos.gruposActivo);
		
		if(listaGrupos !=null){ 			
			try{
				for(int i=0; i<listaGrupos.size(); i++){	
					grupo = (GruposNosolidariosBean)listaGrupos.get(i);
					
					respuestaLista.addSegmento(grupo);
				}
				
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista segmentos para WS", e);
			}			
		}		
	 return respuestaLista;
	}
	
	
	/* lista socios que pertenecen a un grupo no solidario para WS */
	public SP_PDA_Socios_DescargaResponse listaSociosWS(SP_PDA_Socios_DescargaRequest bean){
		SP_PDA_Socios_DescargaResponse respuestaLista = new SP_PDA_Socios_DescargaResponse();			
		List listaSocios;
		GruposNosolidariosBean socio;
		
		listaSocios = gruposNosolidariosDAO.listaSociosWS(bean, Enum_Lis_Grupos.clientesGpo);
		
		if(listaSocios !=null){ 			
			try{
				for(int i=0; i<listaSocios.size(); i++){	
					socio = (GruposNosolidariosBean)listaSocios.get(i);
					
					respuestaLista.addSocio(socio);
				}
				
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista socios para WS", e);
			}			
		}		
	 return respuestaLista;
	}
	
	// Reporte pdf
		public ByteArrayOutputStream reportePDF(GruposNosolidariosBean gruposNosolidariosBean, String nombreReporte ) throws Exception{
			
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				
				parametrosReporte.agregaParametro("Par_NombreInstitucion",gruposNosolidariosBean.getNombreInstitucion());
				parametrosReporte.agregaParametro("Par_NombreUsuario",gruposNosolidariosBean.getNombreUsuario());
				parametrosReporte.agregaParametro("Par_FechaEmision",gruposNosolidariosBean.getFechaEmision());
				parametrosReporte.agregaParametro("Par_GrupoInicial", gruposNosolidariosBean.getGrupoIni());
				parametrosReporte.agregaParametro("Par_GrupoInicialDes",gruposNosolidariosBean.getGrupoIniDes());
				parametrosReporte.agregaParametro("Par_GrupoFinal",gruposNosolidariosBean.getGrupoFin());
				parametrosReporte.agregaParametro("Par_GrupoFinalDes",gruposNosolidariosBean.getGrupoFinDes());
				parametrosReporte.agregaParametro("Par_PromotorInicial", gruposNosolidariosBean.getPromotorIni());
				parametrosReporte.agregaParametro("Par_PromotorInicialDes",gruposNosolidariosBean.getPromotorIniDes());
				parametrosReporte.agregaParametro("Par_PromotorFinal",gruposNosolidariosBean.getPromotorFin());
				parametrosReporte.agregaParametro("Par_PromotorFinalDes", gruposNosolidariosBean.getPromotorFinDes());
				parametrosReporte.agregaParametro("Par_Sucursal", gruposNosolidariosBean.getSucursal());
				parametrosReporte.agregaParametro("Par_SucursalDes", gruposNosolidariosBean.getSucursalDes());
			
				
				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}
		/*case para listas de reportes*/
		public List <GruposNosolidariosBean>listaReporte(int tipoLista, GruposNosolidariosBean bean, HttpServletResponse response){

			 List<GruposNosolidariosBean> listaIntegrantes=null;
		
			switch(tipoLista){
			
				case Enum_Lista_Rep.principal:
					listaIntegrantes = gruposNosolidariosDAO.listaReporte(bean); 
					break;	
			
			}
			
			return listaIntegrantes;
		}
	public GruposNosolidariosDAO getGruposNosolidariosDAO() {
		return gruposNosolidariosDAO;
	}
	public void setGruposNosolidariosDAO(GruposNosolidariosDAO gruposNosolidariosDAO) {
		this.gruposNosolidariosDAO = gruposNosolidariosDAO;
	}

}
