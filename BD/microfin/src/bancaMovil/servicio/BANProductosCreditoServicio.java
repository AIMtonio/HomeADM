package bancaMovil.servicio;

import java.util.List;

import bancaMovil.bean.BANListaProductosCreditoBean;
import bancaMovil.dao.BANProductoCreditoBeDAO;
import general.servicio.BaseServicio;
import herramientas.mapeaBean;

public class BANProductosCreditoServicio extends BaseServicio {

	BANProductoCreditoBeDAO banProductoCreditoBeDAO = null;
	String codigo = "";

	public static interface Enum_Lis_ProductosCreditos {
		int principal = 3;
	}

	public List lista(int tipoLista) {
		List listaResult = null;
		switch (tipoLista) {
		case Enum_Lis_ProductosCreditos.principal:

			BANListaProductosCreditoBean banListaProductosCreditoBean = new BANListaProductosCreditoBean();
			banListaProductosCreditoBean = (BANListaProductosCreditoBean) mapeaBean.valoresDefaultABean(banListaProductosCreditoBean);
			banListaProductosCreditoBean.setNumLis(Integer.toString(Enum_Lis_ProductosCreditos.principal));
			
			
			listaResult = banProductoCreditoBeDAO.listaProductoCreditoBe(banListaProductosCreditoBean);
			break;
		}
		return listaResult;
	}

	public BANProductoCreditoBeDAO getBanProductoCreditoBeDAO() {
		return banProductoCreditoBeDAO;
	}

	public void setBanProductoCreditoBeDAO(BANProductoCreditoBeDAO banProductoCreditoBeDAO) {
		this.banProductoCreditoBeDAO = banProductoCreditoBeDAO;
	}

}
