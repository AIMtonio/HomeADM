package nomina.servicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;


import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import nomina.bean.EmpleadoNominaBean;
import nomina.dao.NominaEmpleadosDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class NominaEmpleadosServicio extends BaseServicio {
	NominaEmpleadosDAO nominaEmpleadosDAO = null;

	public static interface Enum_Tra_NominaEmpleados {
		int alta = 1;
		int baja = 2;
		int actualizacion = 3;
		int modificacion = 4;
	}

	public static interface Enum_Con_NominaEmpleados {
		int empleado 				= 3;
		int clienteRelaNom 			= 4;
		int cliente 				= 5;
		int empleadosBaja 			= 6;
	}

	public static interface Enum_Lis_NominaEmpleados {
		int listaAyuda = 3;
		int listaGrid = 4;
		int listaClie = 5;
	}

	public static interface Enum_Rep_NominaEmpleados {
		int reporteClientes = 1;			// Reporte de pantalla Reporte Clientes Empresa Nomina
	}

	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, EmpleadoNominaBean empleadoNominaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();	
		switch (tipoTransaccion) {
			case Enum_Tra_NominaEmpleados.alta:
				mensaje = nominaEmpleadosDAO.altaEmpleadosNomina(empleadoNominaBean);
				break;

			case Enum_Tra_NominaEmpleados.baja:
				mensaje = nominaEmpleadosDAO.bajaEmpleadosNomina(empleadoNominaBean);
				break;

			case Enum_Tra_NominaEmpleados.modificacion:
				mensaje = nominaEmpleadosDAO.modificacionEmpleadosNomina(empleadoNominaBean);
				break;

		}
		return mensaje;
	}

	public EmpleadoNominaBean consulta(int tipoConsulta, EmpleadoNominaBean empleadoNominaBean) {
		EmpleadoNominaBean resultado = null;

		switch (tipoConsulta) {
		case Enum_Con_NominaEmpleados.empleado:
			resultado = nominaEmpleadosDAO.consultaEmpleadoNomina(tipoConsulta, empleadoNominaBean);
			break;
		case Enum_Con_NominaEmpleados.clienteRelaNom:
			resultado = nominaEmpleadosDAO.consultaClienteEmpNomina(tipoConsulta, empleadoNominaBean);
			break;
		case Enum_Con_NominaEmpleados.cliente:
			resultado = nominaEmpleadosDAO.consultaEmpleadoCliente(tipoConsulta, empleadoNominaBean);
			break;
		case Enum_Con_NominaEmpleados.empleadosBaja:
			resultado = nominaEmpleadosDAO.consultaEmpleadoBaja(tipoConsulta, empleadoNominaBean);
			break;
		}

		return resultado;
	}

	public List<?> lista(int tipoLista, EmpleadoNominaBean empleadoNominaBean) {
		List<?> resultado = null;

		switch (tipoLista) {
		case Enum_Lis_NominaEmpleados.listaAyuda:
			resultado = nominaEmpleadosDAO.listaAyudaEmpleadosNomina(tipoLista, empleadoNominaBean);
			break;
		case Enum_Lis_NominaEmpleados.listaGrid:
			resultado = nominaEmpleadosDAO.listaGridEmpleadosNomina(tipoLista, empleadoNominaBean);
			break;
		case Enum_Lis_NominaEmpleados.listaClie:
			resultado = nominaEmpleadosDAO.listaAyudaEmpleados(tipoLista, empleadoNominaBean);
			break;
		}

		return resultado;
	}
	
	// Controla los tipos de lista para reportes
	public List listaReporte(int tipoReporte, EmpleadoNominaBean empleadoNominaBean, HttpServletResponse response){
		 List resultado = null;

		 switch(tipoReporte){
		 	case  Enum_Rep_NominaEmpleados.reporteClientes:
		 		resultado = nominaEmpleadosDAO.reporteClientesEmpresaNomina(tipoReporte, empleadoNominaBean);
		 		break;
		 }
		return resultado;
	}

	
	//REPORTE DE PDF
	public ByteArrayOutputStream creaRepClientesNomPDF(EmpleadoNominaBean empleadoNominaBean,String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		//ID'S PARAMETROS
		parametrosReporte.agregaParametro("Par_InstitNominaID",empleadoNominaBean.getInstitNominaID());
		parametrosReporte.agregaParametro("Par_ConvNominaID",empleadoNominaBean.getConvenioNominaID());
		parametrosReporte.agregaParametro("Par_FechaIni",empleadoNominaBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",empleadoNominaBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_SucursalID",empleadoNominaBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_ClienteID",empleadoNominaBean.getClienteID());
		
		//PARAMETROS DESCRIPCION
		parametrosReporte.agregaParametro("Par_NombreInstNomina",empleadoNominaBean.getNombreInstNomina());
		parametrosReporte.agregaParametro("Par_DescripcionConvenio",empleadoNominaBean.getDescripcionConvenio());
		parametrosReporte.agregaParametro("Par_NombreSucursal",empleadoNominaBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_NombreCompleto",empleadoNominaBean.getNombreCompleto());
		parametrosReporte.agregaParametro("Par_NomUsuario",empleadoNominaBean.getClaveUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision",empleadoNominaBean.getFechaEmision());


		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	public NominaEmpleadosDAO getNominaEmpleadosDAO() {
		return nominaEmpleadosDAO;
	}

	public void setNominaEmpleadosDAO(NominaEmpleadosDAO nominaEmpleadosDAO) {
		this.nominaEmpleadosDAO = nominaEmpleadosDAO;
	}
}
