package originacion.servicio;
  
import javax.servlet.http.HttpServletRequest;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import originacion.bean.SocDemConyugBean;
import originacion.dao.SocDemoConyugDAO;

public class SocDemoConyugServicio extends BaseServicio {

	SocDemoConyugDAO socDemoConyugDAO=null;
	
	public static interface Enum_Con_Conyugue {
		int principal = 1;
		 
	}
 

	public static interface Enum_Tra_Conyugue {
		int grabar = 1;
	}
	
	
	public SocDemoConyugServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SocDemConyugBean socDemConyugBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_Conyugue.grabar:
			mensaje = socDemoConyugDAO.grabaDatosSocioDemo(socDemConyugBean);
			break;
		}
	return mensaje;	
	}
	
	public SocDemConyugBean consulta(int tipoConsulta, SocDemConyugBean socDemConyugBean){
		SocDemConyugBean socDemConyugResulBean = null;
		switch(tipoConsulta){
		case Enum_Con_Conyugue.principal:
			socDemConyugResulBean = socDemoConyugDAO.consultaPrincipal(socDemConyugBean, tipoConsulta);
			break;
		
		}
		return socDemConyugResulBean;		
	}
	
	public SocDemConyugBean restableceParamsConyugue(SocDemConyugBean socDemConyugBean,
			HttpServletRequest request){
		SocDemConyugBean SocDemConyugResBean = new SocDemConyugBean();
	
		
		SocDemConyugResBean.setProspectoID(request.getParameter("forma3ProspectoID")!=null? request.getParameter("forma3ProspectoID"):"0");
		SocDemConyugResBean.setClienteID(request.getParameter("forma3ClienteID")!=null? request.getParameter("forma3ClienteID"):"0");
		SocDemConyugResBean.setClienteConyID(request.getParameter("buscClienteID")!=null? request.getParameter("buscClienteID"):"0");
		SocDemConyugResBean.setPrimerNombre(request.getParameter("pNombre")!=null?	 request.getParameter("pNombre"):"");
		SocDemConyugResBean.setSegundoNombre(request.getParameter("sNombre")!=null? request.getParameter("sNombre"):"");
		SocDemConyugResBean.setTercerNombre(request.getParameter("tNombre")!=null? request.getParameter("tNombre"):"");
		SocDemConyugResBean.setApellidoPaterno(request.getParameter("aPaterno")!=null? request.getParameter("aPaterno"):"");
		SocDemConyugResBean.setApellidoMaterno(request.getParameter("aMaterno")!=null? request.getParameter("aMaterno"):"");
		SocDemConyugResBean.setNacionaID(socDemConyugBean.getNacionaID());
		SocDemConyugResBean.setPaisNacimiento(socDemConyugBean.getPaisNacimiento());	
		SocDemConyugResBean.setEstadoID(socDemConyugBean.getEstadoID());
		SocDemConyugResBean.setFecNacimiento(socDemConyugBean.getFecNacimiento());
		SocDemConyugResBean.setRfcConyugue(socDemConyugBean.getRfcConyugue());
		SocDemConyugResBean.setTipoIdentiID(socDemConyugBean.getTipoIdentiID());
		SocDemConyugResBean.setFolioIdentificacion(socDemConyugBean.getFolioIdentificacion());
		SocDemConyugResBean.setFechaExpedicion(socDemConyugBean.getFechaExpedicion());
		SocDemConyugResBean.setFechaVencimiento(socDemConyugBean.getFechaVencimiento());
		SocDemConyugResBean.setTelCelular(socDemConyugBean.getTelCelular());
		SocDemConyugResBean.setOcupacionID(socDemConyugBean.getOcupacionID());
		SocDemConyugResBean.setEmpresaLabora(socDemConyugBean.getEmpresaLabora());
		SocDemConyugResBean.setEntFedID(socDemConyugBean.getEntFedID());
		SocDemConyugResBean.setMunicipioID(socDemConyugBean.getMunicipioID());
		SocDemConyugResBean.setLocalidadID(socDemConyugBean.getLocalidadID());
		SocDemConyugResBean.setColoniaID(socDemConyugBean.getColoniaID());
		SocDemConyugResBean.setColonia(socDemConyugBean.getColonia());
		SocDemConyugResBean.setCalle(socDemConyugBean.getCalle());
		SocDemConyugResBean.setNumero(socDemConyugBean.getNumero());
		SocDemConyugResBean.setInterior(socDemConyugBean.getInterior());
		SocDemConyugResBean.setPiso(socDemConyugBean.getPiso());
		SocDemConyugResBean.setAniosAnti(socDemConyugBean.getAniosAnti());
		SocDemConyugResBean.setMesesAnti(socDemConyugBean.getMesesAnti());
		SocDemConyugResBean.setTelEmpresa(socDemConyugBean.getTelEmpresa());
		SocDemConyugResBean.setExtencionTrabajo(socDemConyugBean.getExtencionTrabajo());
		SocDemConyugResBean.setCodPostal(socDemConyugBean.getCodPostal());
		SocDemConyugResBean.setFechaIniTrabajo(socDemConyugBean.getFechaIniTrabajo());
		

		return SocDemConyugResBean;
		
	}
	public void setSocDemoConyugDAO(SocDemoConyugDAO socDemoConyugDAO){
		this.socDemoConyugDAO = socDemoConyugDAO;
	}
	
	public SocDemoConyugDAO getSocDemoConyugDAO(){
		return this.socDemoConyugDAO;
	}
}
