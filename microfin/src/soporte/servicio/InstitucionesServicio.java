package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import soporte.bean.InstitucionesBean;
import soporte.dao.InstitucionesDAO;
import tesoreria.bean.AlgoritmoDepRefBean;

public class InstitucionesServicio extends BaseServicio {
	
	//---------- Variables ------------------------------------------------------------------------
	InstitucionesDAO institucionesDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Institucion{
		int principal = 1;
		int foranea = 2;
		int folio = 3;	
		int participaSpei = 4;
	}

	public static interface Enum_Lis_Institucion {
		int principal = 1;
		int combo = 2;
		int deSucursal = 3;
		int claveSpei  = 4;
		int instiTeso  = 5;
		int instiDepRef  = 7;
	}
	public static interface Enum_Tra_Institucion {
		int alta = 1;
		int modificacion = 2;
		int actualizar = 3;

	}

	public static interface Enum_Lis_Algoritmos {
		int combo = 1;
	}

	
	public InstitucionesServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, InstitucionesBean institucion){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Institucion.alta:		
				mensaje = altaInstitucion(institucion);				
				break;				
			case Enum_Tra_Institucion.modificacion:
				mensaje = modificaInstitucion(institucion);
				break;			
			case Enum_Tra_Institucion.actualizar:
				mensaje = actualizarInstitucion(tipoTransaccion,institucion);
				break;			
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaInstitucion(InstitucionesBean institucion){
		MensajeTransaccionBean mensaje = null;
		mensaje = institucionesDAO.altaInstitucion(institucion);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaInstitucion(InstitucionesBean instituciones){
		MensajeTransaccionBean mensaje = null;
		mensaje = institucionesDAO.modificaInstitucion(instituciones);		
		return mensaje;
	}	

	// METODO PARA ACTUALIZAR SI GENERA DEPOSITOS REFERENCIADOS
	public MensajeTransaccionBean actualizarInstitucion(int tipoTransaccion,InstitucionesBean instituciones){
		MensajeTransaccionBean mensaje = null;
		mensaje = institucionesDAO.actualizarInstitucion(tipoTransaccion,instituciones);		
		return mensaje;
	}
	
	
	public InstitucionesBean consultaInstitucion(int tipoConsulta, InstitucionesBean institucion){
		InstitucionesBean institucionesBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Institucion.principal:		
				institucionesBean = institucionesDAO.consultaPrincipal(institucion, tipoConsulta);				
				break;				
			case Enum_Con_Institucion.foranea:
				institucionesBean = institucionesDAO.consultaForanea(institucion, tipoConsulta);
				break;
			case Enum_Con_Institucion.folio:
				institucionesBean = institucionesDAO.consultaFolio(institucion, tipoConsulta);
				break;
				
			case Enum_Con_Institucion.participaSpei:
				institucionesBean = institucionesDAO.consultaClaveSpei(institucion, tipoConsulta);
				break;
				
				
			
		}
		
		return institucionesBean;
	}
	
	
	public List lista(int tipoLista, InstitucionesBean institucion){		
		List listaInstitucion = null;
		switch (tipoLista) {
			case Enum_Lis_Institucion.principal:		
				listaInstitucion=  institucionesDAO.listaInstitucion(institucion,tipoLista);				
				break;		
			case Enum_Lis_Institucion.deSucursal:		
				listaInstitucion=  institucionesDAO.listaInstitucion(institucion,tipoLista);				
				break;	
			case Enum_Lis_Institucion.claveSpei:		
				listaInstitucion=  institucionesDAO.listaClaveParticipaSpei(institucion,tipoLista);				
				break;	
			case Enum_Lis_Institucion.instiTeso:		
				listaInstitucion=  institucionesDAO.listaInstitucion(institucion,tipoLista);				
				break;	
			case Enum_Lis_Institucion.instiDepRef:		
				listaInstitucion=  institucionesDAO.listaInstitucion(institucion,tipoLista);				
				break;	
		}		
		return listaInstitucion;
	}

	public Object[] listaComboAlg(int tipoLista, AlgoritmoDepRefBean algoritmo){
		List listaAlgoritmos= null;
		switch (tipoLista) {
			case Enum_Lis_Algoritmos.combo:		
				listaAlgoritmos=  institucionesDAO.listaComboAlgoritmos(tipoLista,algoritmo);				
				break;				
		}		
		return listaAlgoritmos.toArray();
	}

	/**public Object[] listaCombo(int tipoLista, InstitucionsBean institucion){
		List listaInstitucion= null;
		switch (tipoLista) {
			case Enum_Lis_Sucursal.combo:		
				listaSucursales=  sucursalesDAO.listaCombo(institucion,tipoLista);				
				break;				
		}		
		return listaInstitucion.toArray();
	}*/ 

	//------------------ Geters y Seters ------------------------------------------------------	
	public void setInstitucionesDAO(InstitucionesDAO institucionesDAO) {
		this.institucionesDAO = institucionesDAO;
	}	
	


}
