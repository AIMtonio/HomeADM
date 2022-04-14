package tarjetas.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;

import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.BitacoraLoteDebBean;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.dao.BitacoraLoteDebDAO;
import tarjetas.dao.TarjetaDebitoDAO;
import tesoreria.bean.ResultadoCargaArchivosTesoreriaBean;

public class BitacoraLoteDebServicio extends  SimpleFormController {	

	BitacoraLoteDebDAO bitacoraLoteDebDAO = null;
	
	public BitacoraLoteDebServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_Tra_BitacoraLoteDeb {
			int alta	= 1;
	}
	
	public static interface Enum_Act_tarjetaDebito {
		int asociaCuentasTarjetaC 		= 1;
	
	}

	public static interface Enum_Con_BitacoraLoteDeb{
		int principal 		= 1;
		int foranea 		= 2;
		
	}
	public static interface Enum_Lis_BitacoraLoteDeb{
		int Fallos		= 1;
		int Exitosos	= 2;
	}
	
	public ResultadoCargaArchivosTesoreriaBean grabaTransaccion(int tipoTransaccion,BitacoraLoteDebBean bitacoraLoteDebBean,String rutaArchivo){
		
		ResultadoCargaArchivosTesoreriaBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_BitacoraLoteDeb.alta:
			mensaje = bitacoraLoteDebDAO.cargaArchTarjetasDeb(bitacoraLoteDebBean, rutaArchivo);
			if(mensaje.getNumero()!=0){
					
			}else{
				mensaje.setNumero(0);
				mensaje.setDescripcion("Archivo Procesado "+
						" Lote: "+bitacoraLoteDebBean.getBitCargaID()+
						" <br>"+mensaje.getDescripcion());
				mensaje.setNombreControl(bitacoraLoteDebBean.getBitCargaID()+"|"+bitacoraLoteDebBean.getExito()+"|"+bitacoraLoteDebBean.getFallo()+"|"+bitacoraLoteDebBean.getRutaArchivo());
		
			}
			break;
		}

		return mensaje;
	}

	public List lista(int tipoLista, BitacoraLoteDebBean bitacoraLoteDebBean){
		List bitacoraCargaLoteLista = null;
		switch (tipoLista) {
	        case  Enum_Lis_BitacoraLoteDeb.Fallos:          
	        	bitacoraCargaLoteLista = bitacoraLoteDebDAO.listaBitacoraCargaLote(bitacoraLoteDebBean, tipoLista);
	        break;
	        case  Enum_Lis_BitacoraLoteDeb.Exitosos:
	        	bitacoraCargaLoteLista = bitacoraLoteDebDAO.listaBitacoraCargaLote(bitacoraLoteDebBean, tipoLista);
	        break;
		}
		return bitacoraCargaLoteLista;
	}
	
	//------------------setter y getter-----------
	
	public BitacoraLoteDebDAO getBitacoraLoteDebDAO() {
		return bitacoraLoteDebDAO;
	}

	public void setBitacoraLoteDebDAO(BitacoraLoteDebDAO bitacoraLoteDebDAO) {
		this.bitacoraLoteDebDAO = bitacoraLoteDebDAO;
	}
	
}