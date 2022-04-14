package cliente.servicio;

import java.util.Iterator;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cliente.dao.EmpleadoNominaDAO;
import cliente.BeanWS.Request.ListaEmpleadoNomRequest;
import cliente.BeanWS.Request.ListaReporteNomBitacoEstEmpRequest;
import cliente.BeanWS.Response.ListaEmpleadoNomResponse;
import cliente.BeanWS.Response.ListaReporteNomBitacoEstEmpResponse;
import cliente.bean.EmpleadoNominaBean;

public class EmpleadoNominaServicio extends BaseServicio {

	EmpleadoNominaDAO empleadoNominaDAO= null;
	String codigo= "";

	public static interface Enum_Con_Empleado {
		int estatus	= 1;
		
	}
	public static interface Enum_Tran_Empleado {
		int actualiza	= 1;
		
	}
	public static interface Enum_Lis_Empleado {
		int listaEmpleadoWS	= 1;
		
	}
	public static interface Enum_Lis_EmpleadoRepEst {
		int listaEmpleadoRepEstWS	= 2;
		
	}
	
	public EmpleadoNominaBean consulta(int tipoConsulta, EmpleadoNominaBean empleadoBean){
		EmpleadoNominaBean empleado = null;
		switch (tipoConsulta) {
		case Enum_Con_Empleado.estatus:
			empleado = empleadoNominaDAO.consultaEstatus(Enum_Con_Empleado.estatus, empleadoBean);
		break;
		
	}
	return empleado;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EmpleadoNominaBean empleadoNom){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tran_Empleado.actualiza:
				mensaje = empleadoNominaDAO.actualizaEstatus(empleadoNom);
				break;
		}
		return mensaje;
	}
	// Lista de Empleados WS
	public Object listaClienteWS(int tipoLista, ListaEmpleadoNomRequest listaEmpleadoNomRequest){
		Object obj= null;
		String cadena = "";
		codigo = "01";
		ListaEmpleadoNomResponse resultadoEmpleado = new ListaEmpleadoNomResponse();
		List<ListaEmpleadoNomResponse> listaEmpleadoNom = empleadoNominaDAO.listaEmpleadosWS(listaEmpleadoNomRequest, tipoLista);
		if (listaEmpleadoNom != null ){
			cadena = transformArray(listaEmpleadoNom);							
		}
		resultadoEmpleado.setListaClientes(cadena);
		resultadoEmpleado.setCodigoRespuesta("0");
		resultadoEmpleado.setMensajeRespuesta("Consulta Exitosa");
		obj=(Object)resultadoEmpleado;
		return obj;
	}

	//Metodo que transforma un Lista en una String con Separadores
	//Separador de Registros &|&, Separador de Campos &;& 
	private String transformArray(List listaEmpleados) {
	    String resultadoEmpleado = "";
	    String separadorCampos = "[";  
	    String separadorRegistros = "]";
	    		
	    EmpleadoNominaBean nominaBean;
	    if(listaEmpleados != null) {   
	        Iterator<EmpleadoNominaBean> it = listaEmpleados.iterator();
	        while(it.hasNext()){    
	        	nominaBean = (EmpleadoNominaBean)it.next();
	        	resultadoEmpleado += nominaBean.getClienteID() + separadorCampos +
	        						 nominaBean.getNombreCompleto() + separadorRegistros;
	        }
	    }
	    if(resultadoEmpleado.length() != 0){
	    	resultadoEmpleado = resultadoEmpleado.substring(0,resultadoEmpleado.length()-3);
	    }
	    return resultadoEmpleado;
	}
	public Object listaRepEstaEmpWS(int tipoLista, ListaReporteNomBitacoEstEmpRequest listaReporteNomBitacoEstEmpRequest){
		Object obj= null;
		String cadena = "";
		codigo = "01";
		ListaReporteNomBitacoEstEmpResponse resultadoEmpleado = new ListaReporteNomBitacoEstEmpResponse();
		List<ListaReporteNomBitacoEstEmpResponse> listaEmpleadoNom = empleadoNominaDAO.listaEstatEmpleadosWS(listaReporteNomBitacoEstEmpRequest, tipoLista);
		if (listaEmpleadoNom != null ){// hacer referencia al metodo que se creo en el DAO
			cadena = transformArray(listaEmpleadoNom,1);							
		}
		resultadoEmpleado.setListaClientes(cadena);
		resultadoEmpleado.setCodigoRespuesta("0");
		resultadoEmpleado.setMensajeRespuesta("Consulta Exitosa");
		obj=(Object)resultadoEmpleado;
		return obj;
	}
	//Override del Metodo para concatenar
	private String transformArray(List listaEmpleados,int lista) {
	    String resultadoEmpleado = "";
	    String separadorCampos = "[";  
	    String separadorRegistros = "]";
	    		
	    EmpleadoNominaBean nominaBean;
	    if(listaEmpleados != null) {   
	        Iterator<EmpleadoNominaBean> it = listaEmpleados.iterator();
	        while(it.hasNext()){    
	        	nominaBean = (EmpleadoNominaBean)it.next();
	        	resultadoEmpleado += nominaBean.getNombreInstNomina()+ separadorCampos 
	        						+nominaBean.getFechaAct()+separadorCampos+
	        						nominaBean.getClienteID()+separadorCampos+
	        						nominaBean.getNombreCompleto()+separadorCampos;
	        						if(nominaBean.getEstatusAnterior().isEmpty())
	        							resultadoEmpleado += " "+separadorCampos;
	        						else
	        							resultadoEmpleado += nominaBean.getEstatusAnterior()+separadorCampos;
	        						if(nominaBean.getEstatusEmp().isEmpty())
	        							resultadoEmpleado += " "+separadorCampos;
	        						else
	        							resultadoEmpleado += nominaBean.getEstatusEmp()+separadorCampos;
	        						if(nominaBean.getFechaInicialInca().isEmpty())
	        							resultadoEmpleado += " "+separadorCampos;
	        						else
	        							resultadoEmpleado += nominaBean.getFechaInicialInca()+separadorCampos;
	        						if(nominaBean.getFechaFinInca().isEmpty())
	        							resultadoEmpleado += " "+separadorCampos;
	        						else
	        							resultadoEmpleado += nominaBean.getFechaFinInca()+separadorCampos;
	        						if(nominaBean.getFechaBaja().isEmpty())
	        							resultadoEmpleado += " "+separadorCampos;
	        						else
	        							resultadoEmpleado += nominaBean.getFechaBaja()+separadorCampos;
	        						if(nominaBean.getMotivoBaja().isEmpty())
	        							resultadoEmpleado += " "+separadorCampos+separadorRegistros;
	        						else
	        							resultadoEmpleado += nominaBean.getMotivoBaja()+separadorCampos+separadorRegistros;
	        }
	    }
	    if(resultadoEmpleado.length() != 0){
	    	resultadoEmpleado = resultadoEmpleado.substring(0,resultadoEmpleado.length()-1);
	    }
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"juanma. String de la Lista" + resultadoEmpleado);
	    return resultadoEmpleado;
	}


// GETERS Y SETERS
	public EmpleadoNominaDAO getEmpleadoNominaDAO() {
		return empleadoNominaDAO;
	}

	public void setEmpleadoNominaDAO(EmpleadoNominaDAO empleadoNominaDAO) {
		this.empleadoNominaDAO = empleadoNominaDAO;
	}
	
	
}
