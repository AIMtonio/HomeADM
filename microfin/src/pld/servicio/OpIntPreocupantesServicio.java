package pld.servicio;

import java.io.File;
import java.util.List;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.task.TaskExecutor;
import org.springframework.util.StringUtils;

import credito.bean.AmortizacionCreditoBean;
import cuentas.bean.CuentasAhoBean;
import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio.Enum_Tra_Cliente;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import gestionComecial.bean.EmpleadosBean;
import gestionComecial.dao.EmpleadosDAO;
import gestionComecial.servicio.EmpleadosServicio.Enum_Con_Empleados;
import gestionComecial.servicio.EmpleadosServicio.Enum_Tra_Empleados;
import herramientas.Constantes;
import herramientas.Utileria;
import pld.bean.MotivosPreoBean;
import pld.bean.OpIntPreocupantesBean;
import pld.bean.ReportesSITIBean;
import pld.dao.EscalamientoPrevioDAO;
import pld.dao.MotivosPreoDAO;
import pld.dao.OpIntPreocupantesDAO;
import pld.servicio.MotivosPreoServicio.Enum_Con_MotivosPreo;
import soporte.PropiedadesSAFIBean;
import soporte.bean.EnvioCorreoBean;
import soporte.bean.ParametrosSisBean;
import soporte.bean.UsuarioBean;
import soporte.dao.EnvioCorreoDAO;
import soporte.servicio.CorreoServicio;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;
import tesoreria.bean.ProveedoresBean;
import tesoreria.servicio.ProveedoresServicio.Enum_Lis_Proveedores;

public class OpIntPreocupantesServicio extends BaseServicio{

	private OpIntPreocupantesServicio(){
		super();
	}
	EnvioCorreoDAO	envioCorreoDAO = null;
	OpIntPreocupantesDAO opIntPreocupantesDAO = null;
	CorreoServicio correoServicio = null;
	UsuarioServicio usuarioServicio = null;
	ParametrosSisServicio parametrosSisServicio=null;
	MotivosPreoServicio motivosPreoServicio =null;

	TaskExecutor taskExecutor;

	public static interface Enum_Con_OpIntPreocupantes{
		int principal = 1;
		int consultaNombre=2;
	}

	public static interface Enum_Tra_OpIntPreocupantes {
		int actualizacion = 1;
		int	alta =2;
		int generaArchivo=5;
		int actEstatusSITI = 6;
	}

	public static interface Enum_Lis_OpIntPreocupantes{
		int alfanumerica = 1;
		int completa = 2;
		int filtroA = 3;
		int filtroB = 4;
		int listaReporte = 5;
		int listaOpeIntPre = 6;
		int listaOpeIntPreExterna=7;
		int listaRepExcel = 8;
	}



	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, OpIntPreocupantesBean opIntPreocupantes){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_OpIntPreocupantes.actualizacion:
				mensaje = actualizacion(opIntPreocupantes);
				break;
			case Enum_Tra_OpIntPreocupantes.alta:
				mensaje = alta(opIntPreocupantes);
				break;
			case Enum_Tra_OpIntPreocupantes.generaArchivo:
				mensaje = opIntPreocupantesDAO.altaHistoricoGeneraReporte(opIntPreocupantes, Enum_Lis_OpIntPreocupantes.listaReporte);

				break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean actualizacion(OpIntPreocupantesBean opIntPreocupantes){
		MensajeTransaccionBean mensaje = null;
		mensaje = opIntPreocupantesDAO.actualizacion(opIntPreocupantes);
		return mensaje;
	}

	public MensajeTransaccionBean alta(final OpIntPreocupantesBean opIntPreocupantes){
		MensajeTransaccionBean mensaje = null;
			mensaje = opIntPreocupantesDAO.alta(opIntPreocupantes);
		return mensaje;
	}


	public OpIntPreocupantesBean consulta(int tipoConsulta, OpIntPreocupantesBean opIntPreocupantes){
		OpIntPreocupantesBean opIntPreocupantesBean = null;
		switch(tipoConsulta){
			case Enum_Con_OpIntPreocupantes.principal:
				opIntPreocupantesBean = opIntPreocupantesDAO.consultaPrincipal(opIntPreocupantes, Enum_Con_OpIntPreocupantes.principal);
			break;
			case Enum_Con_OpIntPreocupantes.consultaNombre:
				opIntPreocupantesBean = opIntPreocupantesDAO.consultaNombreArchivo(opIntPreocupantes, Enum_Con_OpIntPreocupantes.consultaNombre);
			break;
		}
		return opIntPreocupantesBean;

	}



	public List lista(int tipoLista, OpIntPreocupantesBean opIntPreocupantes){
		List listaOpIntPreocupantes = null;
		switch (tipoLista) {
			case Enum_Lis_OpIntPreocupantes.alfanumerica:
				listaOpIntPreocupantes=  opIntPreocupantesDAO.listaAlfanumerica(opIntPreocupantes, Enum_Lis_OpIntPreocupantes.alfanumerica);
				break;
			case Enum_Lis_OpIntPreocupantes.completa:
				listaOpIntPreocupantes=  opIntPreocupantesDAO.listaCompleta(opIntPreocupantes, Enum_Lis_OpIntPreocupantes.completa);
				break;
			case Enum_Lis_OpIntPreocupantes.filtroA:
				listaOpIntPreocupantes=  opIntPreocupantesDAO.listaFiltroA(opIntPreocupantes, Enum_Lis_OpIntPreocupantes.filtroA);
				break;
			case Enum_Lis_OpIntPreocupantes.filtroB:
				listaOpIntPreocupantes=  opIntPreocupantesDAO.listaFiltroB(opIntPreocupantes, Enum_Lis_OpIntPreocupantes.filtroB);
				break;
			case Enum_Lis_OpIntPreocupantes.listaOpeIntPre:
				listaOpIntPreocupantes=  opIntPreocupantesDAO.listaOpeIntPreocupantes(opIntPreocupantes, Enum_Lis_OpIntPreocupantes.listaOpeIntPre);
				break;
			case Enum_Lis_OpIntPreocupantes.listaOpeIntPreExterna:
				listaOpIntPreocupantes=  opIntPreocupantesDAO.listaOpeIntPreocupantesExterna(opIntPreocupantes, Enum_Lis_OpIntPreocupantes.listaOpeIntPre);
				break;
		}
		return listaOpIntPreocupantes;
	}


	/**
	 * Lista las operaciones para el reporte en excel.
	 * @param tipoLista Número de Lista.
	 * @param reporteBean {@link ReportesSITIBean} con los parámetros de entrada a los SPs.
	 * @return Lista con las Operaciones Internas Preocupantes a reportar.
	 * @author avelasco
	 */
	public List listaExcel(int tipoLista, ReportesSITIBean reporteBean){
		List listaOpIntPreocupantes = null;
		switch (tipoLista) {
			case Enum_Lis_OpIntPreocupantes.listaRepExcel:
				listaOpIntPreocupantes = opIntPreocupantesDAO.listaReporteExcel(reporteBean, Enum_Lis_OpIntPreocupantes.listaReporte);
				break;
		}
		return listaOpIntPreocupantes;
	}


	public OpIntPreocupantesDAO getOpIntPreocupantesDAO() {
		return opIntPreocupantesDAO;
	}


	public void setOpIntPreocupantesDAO(OpIntPreocupantesDAO opIntPreocupantesDAO) {
		this.opIntPreocupantesDAO = opIntPreocupantesDAO;
	}

	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public MotivosPreoServicio getMotivosPreoServicio() {
		return motivosPreoServicio;
	}

	public void setMotivosPreoServicio(MotivosPreoServicio motivosPreoServicio) {
		this.motivosPreoServicio = motivosPreoServicio;
	}

	public EnvioCorreoDAO getEnvioCorreoDAO() {
		return envioCorreoDAO;
	}

	public void setEnvioCorreoDAO(EnvioCorreoDAO envioCorreoDAO) {
		this.envioCorreoDAO = envioCorreoDAO;
	}

	public TaskExecutor getTaskExecutor() {
		return taskExecutor;
	}

	public void setTaskExecutor(TaskExecutor taskExecutor) {
		this.taskExecutor = taskExecutor;
	}

}