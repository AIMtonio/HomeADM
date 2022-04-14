package nomina.servicio;
    
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.dao.EstatusNominaDAO;

import nomina.bean.EmpleadoNominaBean;


import nomina.dao.DescuentosNominaDAO;

public class NominaServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	ParametrosSesionBean parametrosSesionBean;
	EstatusNominaDAO nominaDAO = null;
	DescuentosNominaDAO descuentosNominaDAO=null;



	public static interface Enum_Tra_Nomina {
		int alta 			= 1;

	}
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Nomina {
		int principal=1;
		
	}
	
	//List de consulta de Creditos Descuento Nominas
	public static interface Enum_Lis_Nomina {
		int listaNomina= 1;
		int conEstatusRepExcel= 2;
		int conDescuentosNomina=1;

	}
	
	public NominaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
//	
//	//-------------------------------------------------------------------------------------------------
//	// -------------------- CONSULTAS -----------------------------------------------------------------
//	//-------------------------------------------------------------------------------------------------	
//	
//	
//	
//	//-------------------------------------------------------------------------------------------------
//	// -------------------- LISTAS --------------------------------------------------------------------
//	//-------------------------------------------------------------------------------------------------	

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,EmpleadoNominaBean cuentasAho){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_Nomina.alta:
			//mensaje = altaCuentasAho(cuentasAho);
			break;
	}

		return mensaje;
	}
	
	
	public List listaEstatusEmpleadosNomina(int tipoLista, EmpleadoNominaBean nominaBean, HttpServletResponse response){

		// List listaCreditos = null;
		 List listaCreditos=null;
		switch(tipoLista)
		{
		case Enum_Lis_Nomina.conEstatusRepExcel:
		{	
		
			listaCreditos = nominaDAO.listaEstatEmpleados(tipoLista,nominaBean);
			break;
		}
		case Enum_Lis_Nomina.conDescuentosNomina:
			listaCreditos=descuentosNominaDAO.listaDescuentoNomina(tipoLista, nominaBean);
			break;
		}
		return listaCreditos;
	}


	//------------------------------------------------------------------------------------------------
	// -------------------- PROCESOS ------------------------------------------------------------------
	//-------------------------------------------------------------------------------------------------	
	
	
	
	//-------------------------------------------------------------------------------------------------
	//------------------ GETTERS Y SETTERS ------------------------------------------------------------ 
	//-------------------------------------------------------------------------------------------------		
	

	

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public EstatusNominaDAO getNominaDAO() {
		return nominaDAO;
	}

	public void setNominaDAO(EstatusNominaDAO nominaDAO) {
		this.nominaDAO = nominaDAO;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public DescuentosNominaDAO getDescuentosNominaDAO() {
		return descuentosNominaDAO;
	}

	public void setDescuentosNominaDAO(DescuentosNominaDAO descuentosNominaDAO) {
		this.descuentosNominaDAO = descuentosNominaDAO;
	}




	
}
