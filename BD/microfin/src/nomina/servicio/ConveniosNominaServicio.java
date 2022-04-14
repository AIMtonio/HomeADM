package nomina.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;

import nomina.bean.ConvenioNominaBean;
import nomina.bean.TipoEmpleadosConvenioBean;
import nomina.dao.ConveniosNominaDAO;
import nomina.servicio.TipoEmpleadosConvenioServicio.Enum_Lis_Convenios;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class ConveniosNominaServicio extends BaseServicio {
	ConveniosNominaDAO conveniosNominaDAO = null;

	public static interface Enum_Tra_Convenios {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_Convenios {
		int consultaPrincipal = 1;
		int consultaPantalla = 2;
		int consultaNominaInstitucion = 3;
		int consultaReportaIncidencia = 4;
	}

	public static interface Enum_Lis_Convenios {
		int listaAyuda = 1;
		int listaCombo = 2;
		int listaComboTodos = 3;
		int listaCliente = 4;
		int listaClienSolCred = 5;
		int listaAyudaActivosInstitucion = 6;
		int listaAyudaTodos=8;
		int listaPrincipal = 7;
		int listaComboComApert = 9;
		int listaComboMora = 10;

	}

	public static interface Enum_Rep_Convenios {
		int reporteAnaliticoCred = 1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ConvenioNominaBean convenioNominaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		switch (tipoTransaccion) {
		case Enum_Tra_Convenios.alta:
			mensaje = conveniosNominaDAO.altaConveniosNomina(convenioNominaBean);
			break;
		case Enum_Tra_Convenios.modificacion:
			mensaje = conveniosNominaDAO.modificaConveniosNomina(convenioNominaBean);
			break;
		}

		return mensaje;
	}

	public ConvenioNominaBean consulta(int tipoConsulta, ConvenioNominaBean convenioNominaBean) {
		ConvenioNominaBean resultado = null;

		switch (tipoConsulta) {
			case Enum_Con_Convenios.consultaPrincipal:
				resultado = conveniosNominaDAO.consultaConveniosNomina(tipoConsulta, convenioNominaBean);
				break;
			case Enum_Con_Convenios.consultaNominaInstitucion:
				resultado = conveniosNominaDAO.convenioInstitucionNomina(tipoConsulta, convenioNominaBean);
				break;
			case Enum_Con_Convenios.consultaReportaIncidencia:
				resultado = conveniosNominaDAO.consultaReportaIncidencia(tipoConsulta, convenioNominaBean);
				break;
		}
		return resultado;
	}

	public List<?> lista(int tipoLista, ConvenioNominaBean convenioNominaBean){
		List<?> resultado = null;

		switch (tipoLista) {
		case Enum_Lis_Convenios.listaAyuda:			
		case Enum_Lis_Convenios.listaAyudaActivosInstitucion:
			resultado = conveniosNominaDAO.listaConveniosNomina(tipoLista, convenioNominaBean);
			break;
		case Enum_Lis_Convenios.listaCombo:
			resultado = conveniosNominaDAO.listaConveniosActivos(tipoLista, convenioNominaBean);
			break;
		case Enum_Lis_Convenios.listaComboTodos:
			resultado = conveniosNominaDAO.listaComboConvenios(tipoLista, convenioNominaBean);
			break;
		case Enum_Lis_Convenios.listaCliente :
		case Enum_Lis_Convenios.listaClienSolCred :
			resultado =  conveniosNominaDAO.listaConveniosCliente(tipoLista, convenioNominaBean);
			break;
		case Enum_Lis_Convenios.listaAyudaTodos:
			resultado = conveniosNominaDAO.listaConveniosNomina(tipoLista, convenioNominaBean);
			break;
		case Enum_Lis_Convenios.listaComboComApert:
			resultado = conveniosNominaDAO.listaConveniosComApert(tipoLista, convenioNominaBean);
			break;
		case Enum_Lis_Convenios.listaPrincipal :
			resultado =  conveniosNominaDAO.listaPrincipal(tipoLista, convenioNominaBean);
			break;
		}

		return resultado;
	}

	public List<ConvenioNominaBean> listaReporte (int tipoReporte, ConvenioNominaBean convenioNominaBean, HttpServletResponse response) {
		List<ConvenioNominaBean> resultado = null;

		switch (tipoReporte) {
		case Enum_Rep_Convenios.reporteAnaliticoCred:
			//resultado = conveniosNominaDAO.reporteAnaliticoCred(tipoReporte, convenioNominaBean);
			break;
		}

		return resultado;
	}
	
	public List listaCombo(int tipoLista,ConvenioNominaBean convenioNominaBean){
		List cargaListaConvenios = null;
		switch (tipoLista) {
	        case Enum_Lis_Convenios.listaCombo:
	        	cargaListaConvenios = conveniosNominaDAO.listaComboConveniosN(convenioNominaBean,tipoLista);
	       break;
	        case Enum_Lis_Convenios.listaComboMora:
	        	cargaListaConvenios = conveniosNominaDAO.listaComboConvMora(tipoLista,convenioNominaBean);
			break;
		}
		return cargaListaConvenios;
	}



	public ByteArrayOutputStream reporteAnaliticoCreditosPDF(ConvenioNominaBean convenioNominaBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_InstitNominaID", convenioNominaBean.getInstitNominaID());
		parametrosReporte.agregaParametro("Par_ConvenioNominaID", convenioNominaBean.getConvenioNominaID());
		parametrosReporte.agregaParametro("Par_FechaFin", convenioNominaBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_NombreUsuario", convenioNominaBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_FechaSistema", convenioNominaBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", convenioNominaBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_NombreInstitNomina", convenioNominaBean.getNombreInstitNomina());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte,
				parametrosAuditoriaBean.getRutaReportes(),
				parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ConveniosNominaDAO getConveniosNominaDAO() {
		return conveniosNominaDAO;
	}

	public void setConveniosNominaDAO(ConveniosNominaDAO conveniosNominaDAO) {
		this.conveniosNominaDAO = conveniosNominaDAO;
	}
}
