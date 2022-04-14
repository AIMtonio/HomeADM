package inversiones.servicio;

import java.util.List;

import cliente.servicio.SucursalesServicio.Enum_Tra_Sucursal;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import inversiones.bean.BeneficiariosInverBean;
import inversiones.bean.CatPromotoresExtInvBean;
import inversiones.dao.CatPromotoresExtInvDAO;
import inversiones.servicio.BeneficiariosInverServicio.Enum_Lis_BeneficiariosInver;

public class CatPromotoresExtInvServicio extends BaseServicio{
	
	CatPromotoresExtInvDAO catPromotoresExtInvDAO = null;

	public static interface Enum_Tra_PromotorExt {
		int grabar = 1;
		int modificar = 2;
	}
	public static interface Enum_Con_PromotorExt {
		int principal = 1;
	}
	
	public static interface Enum_Lis_PromotorExt{
		int principal = 1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	CatPromotoresExtInvBean catPromotoresExtInvBean) {
		
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_PromotorExt.grabar:		
				mensaje = catPromotorExtAlta(catPromotoresExtInvBean);				
				break;				
			case Enum_Tra_PromotorExt.modificar:		
				mensaje = caPromotorExtInvModifica(catPromotoresExtInvBean);				
				break;	

		}
		return mensaje;
		
	}

	public MensajeTransaccionBean catPromotorExtAlta(CatPromotoresExtInvBean catPromotoresExtInvBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = catPromotoresExtInvDAO.promotorExtAlta(catPromotoresExtInvBean);
		return mensaje;
	}
	
	public MensajeTransaccionBean caPromotorExtInvModifica(CatPromotoresExtInvBean catPromotoresExtInvBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = catPromotoresExtInvDAO.caPromotorExtInvModifica(catPromotoresExtInvBean);
		return mensaje;
	}
	
	
	public CatPromotoresExtInvBean consulta(int tipoConsulta, CatPromotoresExtInvBean catPromotoresBean){
		
		CatPromotoresExtInvBean promotorBean = null;
		
		switch(tipoConsulta){
			case(Enum_Con_PromotorExt.principal):
				promotorBean = catPromotoresExtInvDAO.consultaPrincipal(catPromotoresBean, tipoConsulta);
				break;

		}		
		return promotorBean;		
	}
	
	public List lista(int tipoLista, CatPromotoresExtInvBean catPromotoresExtInvBean){		
		List listaCatPromotoresExtInv = null;
		switch (tipoLista) {
			case Enum_Lis_PromotorExt.principal:		
				listaCatPromotoresExtInv = catPromotoresExtInvDAO.listaPrincipal(catPromotoresExtInvBean, tipoLista);				
				break;
		}		
		return listaCatPromotoresExtInv;
	}	

	
	public CatPromotoresExtInvDAO getCatPromotoresExtInvDAO() {
		return catPromotoresExtInvDAO;
	}

	public void setCatPromotoresExtInvDAO(
			CatPromotoresExtInvDAO catPromotoresExtInvDAO) {
		this.catPromotoresExtInvDAO = catPromotoresExtInvDAO;
	}
	
}
