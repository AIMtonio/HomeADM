package spei.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletResponse;

import spei.bean.CierreDiaSpeiBean;
import spei.dao.CierreDiaSpeiDAO;

public class CierreDiaSpeiServicio extends BaseServicio {

	private CierreDiaSpeiServicio() {
		super();
	}

	CierreDiaSpeiDAO cierreDiaSpeiDAO = null;

	public static interface Enum_Tra_Cierre {
		int alta = 1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,
			CierreDiaSpeiBean cierreDiaSpeiBean) {

		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {

		case Enum_Tra_Cierre.alta:
			mensaje = procesarCierre(cierreDiaSpeiBean, tipoTransaccion);
			break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean procesarCierre(
			CierreDiaSpeiBean cierreDiaSpeiBean, int tipoTransaccion) {
		MensajeTransaccionBean mensaje = null;
		mensaje = cierreDiaSpeiDAO.procesoCierreSpei(cierreDiaSpeiBean,
				tipoTransaccion);
		return mensaje;
	}

	public CierreDiaSpeiDAO getCierreDiaSpeiDAO() {
		return cierreDiaSpeiDAO;
	}

	public void setCierreDiaSpeiDAO(CierreDiaSpeiDAO cierreDiaSpeiDAO) {
		this.cierreDiaSpeiDAO = cierreDiaSpeiDAO;
	}

}
