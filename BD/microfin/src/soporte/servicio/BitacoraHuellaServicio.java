package soporte.servicio;
import java.util.List;
import soporte.bean.BitacoraHuellaBean;
import soporte.dao.BitacoraHuellaDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;

public class BitacoraHuellaServicio extends BaseServicio{
	
	ParametrosSesionBean parametrosSesionBean = null;
	BitacoraHuellaDAO bitacoraHuellaDAO = null;
	
	public static interface Enum_Tra_Bitacora {
		int alta		 = 1;
	}
	
	public static interface Enum_Lis_Bitacora {
        int reporteCliente= 1;      // Reporte de Bitacora Huella en Excel para Cliente
        int reporteUsuario= 2;    // Reporte de Bitacora Huella en Excel para Usuario
	}
	
	public BitacoraHuellaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, BitacoraHuellaBean bitacoraHuellaBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Bitacora.alta:		
				mensaje = bitacoraHuellaDAO.altaBitacora(bitacoraHuellaBean);				
				break;				
		}
		return mensaje;
	}
	/* Case para listas de reportes de Huella */
	public List listaReportesHuella(int tipoLista, BitacoraHuellaBean bitacoraHuellaBean){
		 List listaHuella=null;
	
		switch(tipoLista){
			case Enum_Lis_Bitacora.reporteCliente:
				listaHuella = bitacoraHuellaDAO.consultaBitacoraCli(bitacoraHuellaBean, tipoLista); 
				break;	
			case Enum_Lis_Bitacora.reporteUsuario:
				listaHuella = bitacoraHuellaDAO.consultaBitacoraUsr(bitacoraHuellaBean, tipoLista); 
				break;	
		}
		
		return listaHuella;
	}

	public BitacoraHuellaDAO getBitacoraHuellaDAO() {
		return bitacoraHuellaDAO;
	}

	public void setBitacoraHuellaDAO(BitacoraHuellaDAO bitacoraHuellaDAO) {
		this.bitacoraHuellaDAO = bitacoraHuellaDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
