package ventanilla.servicio;

import java.util.List;
import javax.servlet.http.HttpServletRequest;

import ventanilla.bean.CatalogoRemesasBean;
import ventanilla.dao.CatalogoRemesasDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;

public class CatalogoRemesasServicio extends BaseServicio{	
	
	public CatalogoRemesasServicio(){
		super();
	}
	CatalogoRemesasDAO catalogoRemesasDAO = null;
	ParametrosSesionBean parametrosSesionBean;
	
	public static interface Enum_Trans_CatalogoRemesas{
		int alta= 1;
		int modifica=2;
		
	}
	public static interface Enum_Lis_CatalogoRemesas{
		int principal = 1;
		int listaCombo = 2;		
	}
	public static interface Enum_Con_CatalogoRemesas{
		int principal= 1;
	}
	//Transaccion
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CatalogoRemesasBean catalogoRemesasBean, HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Trans_CatalogoRemesas.alta:
				mensaje = altaCatalogoRemesas(tipoTransaccion, catalogoRemesasBean);
			break;
			case Enum_Trans_CatalogoRemesas.modifica:
				mensaje = modificaCajasVentanilla(tipoTransaccion, catalogoRemesasBean);
			break;
		}
		return mensaje;
	}
	
	//Alta Catalogo de remesas
	public MensajeTransaccionBean altaCatalogoRemesas(int tipoTransaccion, CatalogoRemesasBean catalogoRemesasBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = catalogoRemesasDAO.altaCatalogoRemesas(catalogoRemesasBean);
		return mensaje;
	}
	
	//Modificacion Catalogo de remesas
	public MensajeTransaccionBean modificaCajasVentanilla(int tipoTransaccion, CatalogoRemesasBean catalogoRemesasBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = catalogoRemesasDAO.modificacionCatalogoRemesas(catalogoRemesasBean);
		return mensaje;
	}
	
	
	//consulta Cajas Ventanilla
	public CatalogoRemesasBean consulta(int tipoConsulta, CatalogoRemesasBean catalogoRemesasBean){
		CatalogoRemesasBean catalogoRemesas = null;
		switch(tipoConsulta){
			case Enum_Con_CatalogoRemesas.principal:
				catalogoRemesas = catalogoRemesasDAO.consultaPrincipal(catalogoRemesasBean, tipoConsulta);
			break;	
		}
		return catalogoRemesas;
	}
	
	

	//Lista Cajas Ventanilla
	public List lista(int tipoLista, CatalogoRemesasBean catalogoRemesasBean){
		List listaCatalogoRemesa = null;
		switch (tipoLista) {
		case Enum_Lis_CatalogoRemesas.principal:
			listaCatalogoRemesa=  catalogoRemesasDAO.listaPrincipal(catalogoRemesasBean, tipoLista);
			break;
		}
		return listaCatalogoRemesa;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista,  CatalogoRemesasBean catalogoRemesasBean) {
		List listaTiposCtas = null;
		switch(tipoLista){
			case (Enum_Lis_CatalogoRemesas.listaCombo): 
				listaTiposCtas =  catalogoRemesasDAO.listaCombo(catalogoRemesasBean, tipoLista);
				break;			
		}
		return listaTiposCtas.toArray();		
	}
	
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public CatalogoRemesasDAO getCatalogoRemesasDAO() {
		return catalogoRemesasDAO;
	}

	public void setCatalogoRemesasDAO(CatalogoRemesasDAO catalogoRemesasDAO) {
		this.catalogoRemesasDAO = catalogoRemesasDAO;
	}
}
