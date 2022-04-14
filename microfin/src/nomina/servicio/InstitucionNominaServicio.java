package nomina.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import cliente.servicio.InstitucionNominaServicio.Enum_Con_Institucion;

import tesoreria.bean.AnticipoFacturaBean;
import tesoreria.servicio.AnticipoFacturaServicio.Enum_Act_AnticipoFactura;

import nomina.bean.InstitucionNominaBean;
import nomina.dao.InstitucionNominaDAO;

public class InstitucionNominaServicio extends BaseServicio{

	InstitucionNominaDAO institucionNomDAO = null;

	// ---------- Tipo Transaccion ---------------
	public static interface Enum_Tra_CuentasDest {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	// ---------- Tipo de Consulta ---------------
	public static interface Enum_Con_Institucion {
		int principal	= 1;	
		int bancoCuenta = 5;
		int NumEmpleado = 8;
		int aplicaTabla = 37;
	}
	
	// ---------- Tipo de Lista ---------------
	public static interface Enum_Lis_Institucion{
		int principal 	= 1;
		int clientesNom = 2;
		int instBitDom 	= 3;
		int instNomBit 	= 4;
		int comboTodos	= 5;
	}
	
	// ---------- Tipo de Actualizacion ---------------
	public static interface Enum_Act_Institucion {
		int bajaInstitucion = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,InstitucionNominaBean institucionNominaBean, int tipoActualizacion ) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_CuentasDest.alta:
			mensaje = altaInstitucionNomina(tipoTransaccion,institucionNominaBean);
			break;
		case Enum_Tra_CuentasDest.modificacion:
			mensaje = modificaInstitucionNomina(institucionNominaBean);
			break;
		case Enum_Tra_CuentasDest.baja:
			mensaje = bajaInstitucionNomina(institucionNominaBean, tipoActualizacion);
			break;
		}
		return mensaje;
	}
	public MensajeTransaccionBean altaInstitucionNomina(int tipoTransaccion,InstitucionNominaBean institucionNominaBean) {
		MensajeTransaccionBean mensaje = null;
		mensaje = institucionNomDAO.registraInstitucionNomina(tipoTransaccion,institucionNominaBean);
		return mensaje;
	}
	public MensajeTransaccionBean modificaInstitucionNomina(InstitucionNominaBean institucionNominaBean) {
		MensajeTransaccionBean mensaje = null;
		mensaje = institucionNomDAO.modificarInstitucionNomina(institucionNominaBean);
		return mensaje;
	}

	public MensajeTransaccionBean bajaInstitucionNomina(InstitucionNominaBean institucionNominaBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		switch(tipoActualizacion){
		case Enum_Act_Institucion.bajaInstitucion:
			mensaje = institucionNomDAO.estatusBajaInstitucion(institucionNominaBean,tipoActualizacion);
			break;
			}
		return mensaje;
	}
	
	
	public InstitucionNominaBean consulta(int tipoConsulta, InstitucionNominaBean institucionNominaBean){
		InstitucionNominaBean institucion = null;
		switch (tipoConsulta) {
			case Enum_Con_Institucion.principal:
				institucion = institucionNomDAO.consultaPrincipal(tipoConsulta, institucionNominaBean);
			break;
			case Enum_Con_Institucion.bancoCuenta:
				institucion = institucionNomDAO.consultaBancoCuenta(tipoConsulta, institucionNominaBean);
			break;
			case Enum_Con_Institucion.NumEmpleado:
				institucion = institucionNomDAO.consultaNumeroEmpleado(tipoConsulta, institucionNominaBean);
			break;
			case Enum_Con_Institucion.aplicaTabla:
				institucion = institucionNomDAO.consultaAplicaTabla(tipoConsulta, institucionNominaBean);
			break;
			
		}
		return institucion;
	}
	
	public List lista(int tipoLista, InstitucionNominaBean institucionNominaBean){	
	List listaInstitucionNomina = null;
	switch (tipoLista) {
		case Enum_Lis_Institucion.principal:		
			listaInstitucionNomina = institucionNomDAO.listaInstitucion(tipoLista,institucionNominaBean);		
			break;
		case Enum_Lis_Institucion.clientesNom:		
			listaInstitucionNomina = institucionNomDAO.listaInstitucion(tipoLista,institucionNominaBean);		
			break;
		case Enum_Lis_Institucion.instBitDom:		
			listaInstitucionNomina = institucionNomDAO.listaInstitBitacDomiciPagos(tipoLista,institucionNominaBean);		
			break;
		case Enum_Lis_Institucion.instNomBit:
			listaInstitucionNomina = institucionNomDAO.listaInstitucion(tipoLista, institucionNominaBean);
			break;
	}
	return listaInstitucionNomina;		
	}
	
	/**
	 * Metodo para listar las compañias de nomina, utilizado para combos
	 * @param tipoLista
	 * @return
	 */
	public  Object[] listarCombo(int tipoLista) {
		List lista = null;
		switch(tipoLista){
			case Enum_Lis_Institucion.comboTodos:		
				lista = institucionNomDAO.listarCompaniaTodos(tipoLista);	
			break;
		}
		return lista.toArray();	
	}
	
	public InstitucionNominaDAO getInstitucionNomDAO() {
		return institucionNomDAO;
	}
	public void setInstitucionNomDAO(InstitucionNominaDAO institucionNomDAO) {
		this.institucionNomDAO = institucionNomDAO;
	}
	
}