package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import soporte.servicio.ParamGeneralesServicio;
import originacion.bean.GarantesBean;
import originacion.dao.GarantesDAO;

public class GarantesServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	GarantesDAO garantesDAO = null;
	ParamGeneralesServicio paramGeneralesServicio = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Garante {
		int principal 		= 1;
		int conPersonaFisica	= 2;
	}
	
	public static interface Enum_Lis_Garante {
		int principal 		 = 1;
		int lisPersonaFisica = 2;
		int listaMoral		 = 6;
		
	}
	
	public static interface Enum_Tra_Garante {
		int alta		 = 1;
		int modificacion = 2;
	}

	public GarantesServicio() {
		super();
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, GarantesBean garante){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Garante.alta:		
				mensaje = altaGarante(garante);				
				break;				
			case Enum_Tra_Garante.modificacion:
				mensaje = modificaGarante(garante);				
				break;
			
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaGarante(GarantesBean garante){
		MensajeTransaccionBean mensaje = null;
		
		mensaje = altaGarantes(garante);
		return mensaje;
	}
	
	public MensajeTransaccionBean modificaGarante(GarantesBean cliente){
		MensajeTransaccionBean mensaje = null;
		
		mensaje = modificaGarantes(cliente);
		return mensaje;
	}
	

	public GarantesBean consulta(int tipoConsulta, String numeroGarante){
		GarantesBean garante = null;
		switch (tipoConsulta) {
		
			case Enum_Con_Garante.principal:		
				garante = garantesDAO.consultaPrincipal(Utileria.convierteEntero(numeroGarante), tipoConsulta);				
				break;	
				
			case Enum_Con_Garante.conPersonaFisica:		
				garante = garantesDAO.consultaGarantePF(Utileria.convierteEntero(numeroGarante), tipoConsulta);				
				break;	
		
		}
		if(garante!=null){
			garante.setNumero(Utileria.completaCerosIzquierda(garante.getNumero(), 7));
		}
		
		return garante;
	}
	
	public List lista(int tipoLista, GarantesBean garante){		
		List listaGarantes = null;
		switch (tipoLista) {
			case Enum_Lis_Garante.principal:		
				listaGarantes = garantesDAO.listaPrincipal(garante, tipoLista);				
				break;		
			case Enum_Lis_Garante.lisPersonaFisica:		
				listaGarantes = garantesDAO.listaPrincipal(garante, tipoLista);				
				break;	
			case Enum_Lis_Garante.listaMoral:		
				listaGarantes = garantesDAO.listaPrincipal(garante, tipoLista);				
				break;	
		
			}
		return listaGarantes;
	}
	
	//Alta de Garantes
	public MensajeTransaccionBean altaGarantes(GarantesBean garantes){
		
		MensajeTransaccionBean mensaje = null;
		
		GarantesBean garantesBean = new GarantesBean();
		
		//Se llena el bean dependiendo del tipo de persona
		if(garantes.getTipoPersona().equals("M")){
			garantesBean.setCorreo(garantes.getCorreoPM());
			garantesBean.setTelefono(garantes.getTelefonoPM());
			garantesBean.setExtTelefonoPart(garantes.getExtTelefonoPartPM());
			garantesBean.setFechaConstitucion(garantes.getFechaConstitucionPM());
			garantesBean.setNacionalidad(garantes.getNacionalidadPM());
			
		}else{
			garantesBean.setCorreo(garantes.getCorreo());
			garantesBean.setTelefono(garantes.getTelefono());
			garantesBean.setExtTelefonoPart(garantes.getExtTelefonoPart());
			garantesBean.setFechaConstitucion(garantes.getFechaConstitucion());
			garantesBean.setNacionalidad(garantes.getNacionalidad());
						
		}
		
		mensaje = garantesDAO.altaGarante(garantes,garantesBean);		
		
		return mensaje;
		
	}


	public MensajeTransaccionBean modificaGarantes(GarantesBean garantes){
		
		MensajeTransaccionBean mensaje = null;
		
		GarantesBean garantesBean = new GarantesBean();
		
		//Se llena el bean dependiendo del tipo de persona
		if(garantes.getTipoPersona().equals("M")){
			garantesBean.setCorreo(garantes.getCorreoPM());
			garantesBean.setTelefono(garantes.getTelefonoPM());
			garantesBean.setExtTelefonoPart(garantes.getExtTelefonoPartPM());
			garantesBean.setFechaConstitucion(garantes.getFechaConstitucionPM());
			garantesBean.setNacionalidad(garantes.getNacionalidadPM());
			
		}else{
			garantesBean.setCorreo(garantes.getCorreo());
			garantesBean.setTelefono(garantes.getTelefono());
			garantesBean.setExtTelefonoPart(garantes.getExtTelefonoPart());
			garantesBean.setFechaConstitucion(garantes.getFechaConstitucion());
			garantesBean.setNacionalidad(garantes.getNacionalidad());
						
		}
		mensaje = garantesDAO.modificaGarante(garantes, garantesBean);
		return mensaje;
		
	}

	
	public GarantesDAO getGarantesDAO() {
		return garantesDAO;
	}

	public void setGarantesDAO(GarantesDAO garantesDAO) {
		this.garantesDAO = garantesDAO;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}
	


	
} 
