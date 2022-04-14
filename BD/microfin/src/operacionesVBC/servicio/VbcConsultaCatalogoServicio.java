package operacionesVBC.servicio;

import operacionesVBC.bean.VbcConsultaCatalogoBean;
import operacionesVBC.beanWS.request.VbcConsultaCatalogoRequest;
import operacionesVBC.beanWS.response.VbcConsultaCatalogoResponse;
import operacionesVBC.dao.VbcConsultaCatalogoDAO;
import general.servicio.BaseServicio;

import java.util.List;
public class VbcConsultaCatalogoServicio extends BaseServicio{

	VbcConsultaCatalogoDAO vbcConsultaCatalogoDAO = null;
	
	public VbcConsultaCatalogoServicio(){
		super();
		// TODO Auto-generated constructor stub
	}

	public VbcConsultaCatalogoResponse listaOtrosCatWS(VbcConsultaCatalogoRequest bean){
	  VbcConsultaCatalogoResponse respuestaLista = new VbcConsultaCatalogoResponse();			
	   List listaOtrosCat;
	   VbcConsultaCatalogoBean otrosCat;
	   listaOtrosCat = vbcConsultaCatalogoDAO.listaCatalogosWS(bean);
	   if(listaOtrosCat !=null){
		try{
			for(int i=0; i<listaOtrosCat.size(); i++){	
				otrosCat = (VbcConsultaCatalogoBean)listaOtrosCat.get(i);
				respuestaLista.addOtrosCat(otrosCat);
				}
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta CatalogosServicio WS", e);
				}			
	   }else{
		   respuestaLista.setCodigoRespuesta("01");
		   respuestaLista.setMensajeRespuesta("El Catalogo No Existe");
	   }
	   
	   return respuestaLista;
	}

	
	public VbcConsultaCatalogoDAO getVbcConsultaCatalogoDAO() {
		return vbcConsultaCatalogoDAO;
	}

	public void setVbcConsultaCatalogoDAO(
			VbcConsultaCatalogoDAO vbcConsultaCatalogoDAO) {
		this.vbcConsultaCatalogoDAO = vbcConsultaCatalogoDAO;
	}	
}