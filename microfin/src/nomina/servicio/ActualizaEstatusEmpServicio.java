package nomina.servicio;

import java.util.List;

import nomina.bean.ActualizaEstatusEmpBean;
import nomina.dao.ActualizaEstatusEmpDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class ActualizaEstatusEmpServicio extends BaseServicio {
	ActualizaEstatusEmpDAO actualizaEstatusEmpDAO = null;
	
	// ---------- Tipo Transaccion ---------------
	public static interface Enum_Tran_Empleado {
		int actualiza	= 1;
		
	}
	// ---------- Tipo de Consulta ---------------
	public static interface Enum_Con_Empleado {
		int estatusEmpleado	= 2;
		
	}
	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_Empleado {
		int listaEmpleado	= 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ActualizaEstatusEmpBean actualizaEstatusEmpBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tran_Empleado.actualiza:
				mensaje = actualizaEstatusEmpDAO.actualizaEstatus(actualizaEstatusEmpBean);
				break;
		}
		return mensaje;
	}
	
	public ActualizaEstatusEmpBean consulta(int tipoConsulta, ActualizaEstatusEmpBean actualizaEstatusEmpBean){
		ActualizaEstatusEmpBean empleado = null;
		switch (tipoConsulta) {
		case Enum_Con_Empleado.estatusEmpleado:
			empleado = actualizaEstatusEmpDAO.consultaEstatus(tipoConsulta,actualizaEstatusEmpBean);
		break;
		
	}
	return empleado;
	}
	
	public List lista(int tipoLista, ActualizaEstatusEmpBean actualizaEstatusEmpBean){	
	List listaEmpleados = null;
	switch (tipoLista) {
		case Enum_Lis_Empleado.listaEmpleado:		
			listaEmpleados = actualizaEstatusEmpDAO.listaEmpleado(tipoLista,actualizaEstatusEmpBean);		
			break;
			}
	return listaEmpleados;		
	}
	

	// GETERS Y SETERS
	public ActualizaEstatusEmpDAO getActualizaEstatusEmpDAO() {
		return actualizaEstatusEmpDAO;
	}

	public void setActualizaEstatusEmpDAO(
			ActualizaEstatusEmpDAO actualizaEstatusEmpDAO) {
		this.actualizaEstatusEmpDAO = actualizaEstatusEmpDAO;
	}
	
	
}