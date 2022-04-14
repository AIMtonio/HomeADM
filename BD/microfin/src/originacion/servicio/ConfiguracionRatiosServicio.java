package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import originacion.bean.ConfiguracionRatiosBean;
import originacion.dao.ConfiguracionRatiosDAO;

public class ConfiguracionRatiosServicio extends BaseServicio {
	ConfiguracionRatiosDAO	configuracionRatiosDAO;
	
	public static interface Enum_tran_RatiosConf {
		int	altaConcepto			= 1;
		int	altaClasificacion		= 2;
		int	altaSubClasificacion	= 3;
		int	altaPuntos				= 4;
	}
	
	public static interface Enum_Lis_RatiosConf {
		int	listaXConcepto			= 1;
		int	listaXClasificacion		= 2;
		int	listaXSubClasificacion	= 3;
		int	listaXPuntos			= 4;
	}
	
	/**
	 * Método para listar las configuraciones de ratios por producto.
	 * @param tipoLista: Número de Lista.
	 * @param configuracionRatiosBean: Contiene los datos para filtrar la lista.
	 * @return List<ConfiguracionRatiosBean>: Retorna la lista con la configuración.
	 */
	public List<ConfiguracionRatiosBean> lista(int tipoLista, ConfiguracionRatiosBean configuracionRatiosBean) {
		List<ConfiguracionRatiosBean> lista = null;
		try {
			switch (tipoLista) {
				case Enum_Lis_RatiosConf.listaXConcepto:
				case Enum_Lis_RatiosConf.listaXClasificacion:
				case Enum_Lis_RatiosConf.listaXSubClasificacion:
					lista = configuracionRatiosDAO.listaxPorcentaje(configuracionRatiosBean, tipoLista);
					break;
				case Enum_Lis_RatiosConf.listaXPuntos:
					lista = configuracionRatiosDAO.listaxLimites(configuracionRatiosBean, tipoLista);
					break;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return lista;
	}
	
	/**
	 * Método para guardar la configuración de ratios por producto de Crédito
	 * @param listaDetalles: List con las configuraciones de ratios x producto
	 * @param tipoTransaccion: Numero de transacción segun {@link Enum_tran_RatiosConf}
	 * @return
	 */
	public MensajeTransaccionBean graba(List<ConfiguracionRatiosBean> listaDetalles, int tipoTransaccion) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_tran_RatiosConf.altaConcepto:
			case Enum_tran_RatiosConf.altaClasificacion:
			case Enum_tran_RatiosConf.altaSubClasificacion:
			case Enum_tran_RatiosConf.altaPuntos:
				mensaje = configuracionRatiosDAO.graba(listaDetalles, tipoTransaccion);
				break;
		}
		
		return mensaje;
	}
	
	public ConfiguracionRatiosDAO getConfiguracionRatiosDAO() {
		return configuracionRatiosDAO;
	}
	
	public void setConfiguracionRatiosDAO(ConfiguracionRatiosDAO configuracionRatiosDAO) {
		this.configuracionRatiosDAO = configuracionRatiosDAO;
	}
	
}
