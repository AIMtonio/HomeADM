package cliente.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;
 
import javax.servlet.http.HttpServletResponse;

import credito.bean.CreCastigosRepBean;
import credito.servicio.CastigosCarteraServicio.Enum_Lis_ReporteCastigos;
import reporte.ParametrosReporte;
import reporte.Reporte;
import cliente.bean.LocalidadRepubBean;
import cliente.bean.MunicipiosRepubBean;
import cliente.bean.ReporteLocalidadesMarginadasBean;
import cliente.dao.LocalidadRepubDAO;
import cliente.servicio.MunicipiosRepubServicio.Enum_Con_Municipios;
import cliente.servicio.MunicipiosRepubServicio.Enum_Lis_Municipios;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class LocalidadRepubServicio extends BaseServicio{
	LocalidadRepubDAO localidadRepubDAO = null;
	public static interface Enum_Con_Municipios {
		int principal   = 1;
		int foranea     = 2;
		int regulatorio = 3;
		int regSofipo   = 4;
	}

	public static interface Enum_Lis_Municipios {
		int principal   = 1;
		int regulatorio = 2;
		int regSofipo   = 3;
	}
	public static interface Enum_Lis_ReporteLocalidadesMarginadas {
		int locMarginadas = 1;
	}
	public LocalidadRepubServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	public List lista(int tipoLista, LocalidadRepubBean localidad) {
		// TODO Auto-generated method stub
		List ListaLocalidad= null;
		switch (tipoLista) {
		case Enum_Lis_Municipios.principal:		
			ListaLocalidad=  localidadRepubDAO.listaLocalidad(localidad,tipoLista);				
			break;	
		case Enum_Lis_Municipios.regulatorio:		
			ListaLocalidad=  localidadRepubDAO.listaLocalidadCNBV(localidad,tipoLista);				
			break;
		case Enum_Lis_Municipios.regSofipo:		
			ListaLocalidad=  localidadRepubDAO.listaLocalidadCNBV(localidad,tipoLista);				
			break;
	}		
	return ListaLocalidad;
		
	}
	
			
	public LocalidadRepubBean consulta(int tipoConsulta,String estadoID, String municipioID, String localidadID){
		LocalidadRepubBean localidades = null;
		
		switch(tipoConsulta){
		case Enum_Con_Municipios.principal:
			localidades = localidadRepubDAO.consultaPrincipal(Integer.parseInt(estadoID),Integer.parseInt(municipioID),Integer.parseInt(localidadID),Enum_Con_Municipios.principal);
		break;
		case Enum_Con_Municipios.regulatorio:
			localidades = localidadRepubDAO.consultaLocalidadCNBV(Integer.parseInt(estadoID),Integer.parseInt(municipioID),localidadID,tipoConsulta);
		break;
		case Enum_Con_Municipios.regSofipo:
			localidades = localidadRepubDAO.consultaLocalidadCNBV(Integer.parseInt(estadoID),Integer.parseInt(municipioID),localidadID,tipoConsulta);
		break;
		}
		
		return localidades;
	}
	
	// Reporte  de Localidades Marginadas pdf
	public ByteArrayOutputStream creaRepLocalidadesMarginadasPDF(ReporteLocalidadesMarginadasBean reporteLocalidadesMarginadasBean,String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
			
		parametrosReporte.agregaParametro("Par_EstadoID",(!reporteLocalidadesMarginadasBean.getEstadoMarginadasID().isEmpty())? reporteLocalidadesMarginadasBean.getEstadoMarginadasID():"TODOS");
		parametrosReporte.agregaParametro("Par_NombreEstado",(reporteLocalidadesMarginadasBean.getNombreEstadoMarginadas()));
		parametrosReporte.agregaParametro("Par_MunicipioID",(!reporteLocalidadesMarginadasBean.getMunicipioMarginadasID().isEmpty())? reporteLocalidadesMarginadasBean.getMunicipioMarginadasID():"TODOS");
		parametrosReporte.agregaParametro("Par_NombreMunicipio",reporteLocalidadesMarginadasBean.getNombreMunicipioMarginadas());
		parametrosReporte.agregaParametro("Par_LocalidadID",(!reporteLocalidadesMarginadasBean.getLocalidadMarginadasID().isEmpty())? reporteLocalidadesMarginadasBean.getLocalidadMarginadasID():"TODOS");
		parametrosReporte.agregaParametro("Par_NombreLocalidad",reporteLocalidadesMarginadasBean.getNombreLocalidadMarginadas());

		parametrosReporte.agregaParametro("Par_NombreInstitucion",(!reporteLocalidadesMarginadasBean.getNombreInstitucion().isEmpty())?reporteLocalidadesMarginadasBean.getNombreInstitucion(): "TODOS");
		parametrosReporte.agregaParametro("Par_NombreUsuario",reporteLocalidadesMarginadasBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision",reporteLocalidadesMarginadasBean.getFechaEmision());			
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	public List listaRepLocalidadesMarginadasExcel(int tipoLista, 
													ReporteLocalidadesMarginadasBean reporteLocalidadesMarginadasBean, 
														HttpServletResponse response){
			 List listaLocalidades=null;
		switch(tipoLista){		
			case Enum_Lis_ReporteLocalidadesMarginadas.locMarginadas:
				listaLocalidades = localidadRepubDAO.listaLocalidadesMarginadas(reporteLocalidadesMarginadasBean, tipoLista); 
				break;	
		}
		
		return listaLocalidades;
	}
	
	
	public LocalidadRepubDAO getLocalidadRepubDAO() {
		return localidadRepubDAO;
	}
	public void setLocalidadRepubDAO(LocalidadRepubDAO localidadRepubDAO) {
		this.localidadRepubDAO = localidadRepubDAO;
	}
	
	
}
