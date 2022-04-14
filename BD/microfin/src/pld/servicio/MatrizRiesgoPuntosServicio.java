package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import pld.bean.MatrizRiesgoPuntosBean;
import pld.dao.MatrizRiesgoPuntosDAO;

public class MatrizRiesgoPuntosServicio extends BaseServicio {
	MatrizRiesgoPuntosDAO	matrizRiesgoPuntosDAO;
	public static interface Enum_Tran_MatrizRiesgoPuntos {
		int	actualizacion			= 1;
	}
	public static interface Enum_Lis_MatrizRiesgoPuntos {
		int	listaXConcepto			= 1;
		int listaXClasificacion		= 2;
		int listaXSubClasificacion		= 3;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, MatrizRiesgoPuntosBean bean) {
		MensajeTransaccionBean mensaje = null;
		try {
			switch (tipoTransaccion) {
				case Enum_Tran_MatrizRiesgoPuntos.actualizacion:
					List<MatrizRiesgoPuntosBean> lista = listaDetalles(bean.getDetalles());
					mensaje = matrizRiesgoPuntosDAO.graba(lista, tipoTransaccion);
					break;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(777);
				mensaje.setDescripcion("Error al guardar la Configuración de la Matriz de Riesgo."+ex.getMessage());
			}
		}
		return mensaje;
	}
	
	public List<MatrizRiesgoPuntosBean> lista(int tipoLista, MatrizRiesgoPuntosBean bean) {
		List<MatrizRiesgoPuntosBean> lista = null;
		try {
			switch (tipoLista) {
				case Enum_Lis_MatrizRiesgoPuntos.listaXConcepto:
				case Enum_Lis_MatrizRiesgoPuntos.listaXClasificacion:
				case Enum_Lis_MatrizRiesgoPuntos.listaXSubClasificacion:
					lista = matrizRiesgoPuntosDAO.listaxPorcentaje(bean, tipoLista);
					break;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return lista;
	}

	public List<MatrizRiesgoPuntosBean> listaDetalles(String detalle) {
		try {
			List<MatrizRiesgoPuntosBean> listaDetalle = new ArrayList<MatrizRiesgoPuntosBean>();
			StringTokenizer tokensBean = new StringTokenizer(detalle, "[");
			String stringCampos;
			String tokensCampos[];
			while (tokensBean.hasMoreTokens()) {
				MatrizRiesgoPuntosBean conf = new MatrizRiesgoPuntosBean();
				stringCampos = tokensBean.nextToken();
				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				conf.setMatrizCatalogoID(tokensCampos[0]);
				conf.setPorcentaje(tokensCampos[1]);
				listaDetalle.add(conf);
			}
			return listaDetalle;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public MatrizRiesgoPuntosDAO getMatrizRiesgoPuntosDAO() {
		return matrizRiesgoPuntosDAO;
	}
	
	public void setMatrizRiesgoPuntosDAO(MatrizRiesgoPuntosDAO matrizRiesgoPuntosDAO) {
		this.matrizRiesgoPuntosDAO = matrizRiesgoPuntosDAO;
	}
}
