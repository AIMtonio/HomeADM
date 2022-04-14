package arrendamiento.servicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import arrendamiento.bean.DepositoRefereArrendaBean;
import arrendamiento.bean.ResultadoCargaArchivosArrendaBean;
import arrendamiento.dao.DepositoRefereArrendaDAO;

public class DepositoRefereArrendaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	DepositoRefereArrendaDAO depositoRefereArrendaDAO = null;	

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Arrenda {
		int principal = 1;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Arrenda {
		int principal = 1;
		int depositos = 2;
	}

	//---------- Tipo de Transaccion ----------------------------------------------------------------	
	public static interface Enum_Tra_Arrenda {
		int alta	= 1;
		int aplica	= 2;
	}
	
	public DepositoRefereArrendaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, DepositoRefereArrendaBean depositoRefereArrendaBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Arrenda.alta:		
				mensaje = depositoRefereArrendaDAO.aplicaDepositos(depositoRefereArrendaBean);				
				break;		
		}
		return mensaje;
	}
	
	
	public List lista(int tipoLista, DepositoRefereArrendaBean depositoRefereArrendaBean){		
		List listaDepositoRefere = null;
		switch (tipoLista) {
			case Enum_Lis_Arrenda.principal:		
				listaDepositoRefere = depositoRefereArrendaDAO.listaPrincipalDepRefere(tipoLista, depositoRefereArrendaBean);				
				break;
			case Enum_Lis_Arrenda.depositos:		
				listaDepositoRefere = depositoRefereArrendaDAO.listaDepositosRefere(tipoLista, depositoRefereArrendaBean);				
				break;
		}	
		return listaDepositoRefere;
	}


	public DepositoRefereArrendaBean consulta(int tipoConsulta, DepositoRefereArrendaBean depositoRefereArrendaBean){
		DepositoRefereArrendaBean depositoRefere = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.principal:		
				depositoRefere = depositoRefereArrendaDAO.consultaPrincipal(depositoRefereArrendaBean, tipoConsulta);				
				break;	
		}
		return depositoRefere;
	}
	
	public ResultadoCargaArchivosArrendaBean cargaArchivoDepRefere(String rutaArchivo, DepositoRefereArrendaBean depositosRefeBean){
		int intitucionID = Integer.parseInt(depositosRefeBean.getInstitucionID());
		ResultadoCargaArchivosArrendaBean resultadoCarga =new ResultadoCargaArchivosArrendaBean();

		// si en la pantalla no se selecciono formato banco, quiere decir que seleccionaron el 
		// formato estandar entonces se ejecuta el metodo de la cargar por formato estandar
		resultadoCarga= depositoRefereArrendaDAO.cargaArchivo(rutaArchivo, depositosRefeBean);
		if(resultadoCarga.getNumero()!=0){
		}else{
			resultadoCarga.setNumero(0);
			resultadoCarga.setConsecutivoInt("123");
			resultadoCarga.setConsecutivoString("0000123");
			if(resultadoCarga.getExitosos() <= 0){
				resultadoCarga.setDescripcion(resultadoCarga.getDescripcion());
			}
			resultadoCarga.setDescripcion("Proceso Exitoso."+
					" <br> "+resultadoCarga.getDescripcion());
			resultadoCarga.setNombreControl("institucionID");
		}
	
		return resultadoCarga;	
	}

	
	//------------------ Geters y Seters ------------------------------------------------------	
	public DepositoRefereArrendaDAO getDepositoRefereArrendaDAO() {
		return depositoRefereArrendaDAO;
	}


	public void setDepositoRefereArrendaDAO(
			DepositoRefereArrendaDAO depositoRefereArrendaDAO) {
		this.depositoRefereArrendaDAO = depositoRefereArrendaDAO;
	}
			
}


