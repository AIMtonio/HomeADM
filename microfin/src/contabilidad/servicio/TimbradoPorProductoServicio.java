package contabilidad.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import contabilidad.bean.TimbradoPorProductoBean;
import contabilidad.dao.TimbradoPorProductoDAO;



public class TimbradoPorProductoServicio extends BaseServicio  {

	TimbradoPorProductoDAO timbradoPorProductoDAO;
	
	public static interface Enum_Trans_TimPorProducto{
		int generarCadena = 1;
		int timbrarProd   = 2;
	}
	
	public static interface Enum_Con_ProdTimbrados{
		int principal = 1;
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	TimbradoPorProductoBean timbradoPorProductoBean){
		
		ArrayList listaProducto = (ArrayList) creaListaProducto(timbradoPorProductoBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Trans_TimPorProducto.generarCadena:
				mensaje = timbradoPorProductoDAO.generacionCadenasCrediClub(timbradoPorProductoBean);				
			break ;
			case Enum_Trans_TimPorProducto.timbrarProd:		
				mensaje = timbradoPorProductoDAO.realizarTimbradoCrediClub(timbradoPorProductoBean);
			break ;
		}
	return mensaje;
		
	}

	public TimbradoPorProductoBean consulta(int tipoConsulta, TimbradoPorProductoBean timbradoPorProductoBean){
		TimbradoPorProductoBean timbradoPorProducto =	null;
		switch(tipoConsulta){
			case Enum_Con_ProdTimbrados.principal:
				timbradoPorProducto=timbradoPorProductoDAO.consultaTimbradoProd(tipoConsulta,timbradoPorProductoBean);				
			break;		
		}		
		return timbradoPorProducto;
	}
	
	public List creaListaProducto(TimbradoPorProductoBean timbradoPorProductoBean) {
		List<String> product  = timbradoPorProductoBean.getLproductoCredID();
		String CadenaProductos="";
		ArrayList listaProd = new ArrayList();
		TimbradoPorProductoBean timbradoPorProd = null;	
		
		if(product != null){
			int tamanio = product.size();			
			for (int i = 0; i < tamanio; i++) {
				timbradoPorProd = new TimbradoPorProductoBean();
				
				timbradoPorProd.setTipoGeneracion(timbradoPorProductoBean.getTipoGeneracion());
				timbradoPorProd.setAnioGeneracion(timbradoPorProductoBean.getAnio());
				timbradoPorProd.setAnio(timbradoPorProductoBean.getAnio());
				timbradoPorProd.setMesInicioGen(timbradoPorProductoBean.getMes());
				timbradoPorProd.setMesFinGen(timbradoPorProductoBean.getMes());
				timbradoPorProd.setMes(timbradoPorProductoBean.getMes());
				timbradoPorProd.setSemestre(timbradoPorProductoBean.getSemestre());
				if(i==0){
					CadenaProductos = "'"+product.get(i);
				}
				else{
					CadenaProductos = CadenaProductos+","+product.get(i);
				}
				timbradoPorProd.setProductoCredID(product.get(i));
				listaProd.add(timbradoPorProd);
			}
			timbradoPorProd.setProductos(CadenaProductos+"'");
			timbradoPorProductoBean.setProductos(CadenaProductos+"'");
		}
	return listaProd;
		
	}
	
	
	
	public TimbradoPorProductoDAO getTimbradoPorProductoDAO() {
		return timbradoPorProductoDAO;
	}

	public void setTimbradoPorProductoDAO(
			TimbradoPorProductoDAO timbradoPorProductoDAO) {
		this.timbradoPorProductoDAO = timbradoPorProductoDAO;
	}
	
}
