package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import soporte.bean.InstitucionesBean;
import soporte.servicio.InstitucionesServicio;
import tesoreria.bean.DepositosRefeBean;
import tesoreria.bean.ResultadoCargaArchivosTesoreriaBean;
import tesoreria.dao.DepositosRefeDAO;

public class DepositosRefeServicio extends BaseServicio {

	DepositosRefeDAO depositosRefeDAO;
	InstitucionesServicio institucionesServicio = null;
	public static interface Enum_Tra_tesoMovs {
		int alta = 1;
		int modificacion = 2;
		int elimina =3;

	}
	public static interface Enum_Tra_depositos {
		int aplicados = 3;
		int borraCarga= 4;

	}
	public static interface Enum_Tra_Inserta {
		String grabaTabla = "S";
	}
	
	public static interface Enum_Lis_DepositosRefere{
		int lisDepositosRef	= 1;
	}
	public static interface Enum_Con_Depositos {
		int conValidaciones	= 1;
		int conNumIdArch    = 2;
	}

	String formatoBanco = "B";
	String formatoEstandar = "E";
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, DepositosRefeBean depositosRefeBean, String bancoEstandar){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){		
	    	case Enum_Tra_depositos.aplicados:
				mensaje = depositoAplicado(depositosRefeBean,tipoTransaccion,bancoEstandar);
	    		break;		
		}
		return mensaje;
	}
	
	
	
	public ResultadoCargaArchivosTesoreriaBean cargaArchivoDepRefere(String rutaArchivo, DepositosRefeBean depositosRefeBean, String bancoEstandar){
		int institucionID = Utileria.convierteEntero(depositosRefeBean.getInstitucionID());
		ResultadoCargaArchivosTesoreriaBean resultadoCarga =new ResultadoCargaArchivosTesoreriaBean();
		depositosRefeBean.setBancoEstandar(bancoEstandar);
		if(bancoEstandar.equals(formatoBanco)){
			switch(institucionID){
				case 9:resultadoCarga= depositosRefeDAO.cargaArchivoBanamex(rutaArchivo, depositosRefeBean);
					break;
				case 24:resultadoCarga= depositosRefeDAO.cargaArchivoBanorte(rutaArchivo, depositosRefeBean);
					break;
				case 37:
					InstitucionesBean institucionBean = new InstitucionesBean();
					institucionBean.setInstitucionID(institucionID+"");
					institucionBean = institucionesServicio.consultaInstitucion(1, institucionBean);
					int algoritmoID = Utileria.convierteEntero(institucionBean.getAlgoritmoID());
					switch(algoritmoID){
						case 2:	resultadoCarga= depositosRefeDAO.cargaArchivoBancomer(rutaArchivo,depositosRefeBean);
						break;
						case 5: resultadoCarga = depositosRefeDAO.cargaArchivoBancomerALG36( rutaArchivo, depositosRefeBean);
						break;
						default:
							resultadoCarga.setNumero(1);
							resultadoCarga.setConsecutivoString("0");
							resultadoCarga.setConsecutivoInt("0");
							resultadoCarga.setNombreControl("file");
							resultadoCarga.setDescripcion("El formato del archivo no es compatible con el Algoritmo del Banco especificado.");
						break;
					}
				break;
				default:
					resultadoCarga.setNumero(1);
					resultadoCarga.setConsecutivoString("0");
					resultadoCarga.setConsecutivoInt("0");
					resultadoCarga.setNombreControl("file");
					resultadoCarga.setDescripcion("No se encuentra diseñada la carga para este Banco.");
					break;
			}
		}else{
			// si en la pantalla no se selecciono formato banco, quiere decir que seleccionaron el 
			// formato estandar entonces se ejecuta el metodo de la cargar por formato estandar
			
			//VALIDAMOS EL PARAMETRO SI VA SER EL FORMATO ESTANDAR TXT, O LA NUEVA VERSION FORMATO EXCEL(XLS)
			if(depositosRefeBean.getCargaLayoutXLSDepRef().equals("S")){
				resultadoCarga= depositosRefeDAO.cargaArchivoXLS(rutaArchivo, depositosRefeBean);								
			}else{
				resultadoCarga= depositosRefeDAO.cargaArchivo(rutaArchivo, depositosRefeBean);	
				
				if(resultadoCarga.getNumero()!=0){
				}else{
					resultadoCarga.setNumero(0);
					if(resultadoCarga.getExitosos() <= 0){
						resultadoCarga.setDescripcion(resultadoCarga.getDescripcion());
					}
					resultadoCarga.setDescripcion(resultadoCarga.getDescripcion());
					resultadoCarga.setNombreControl("institucionID");
				}							
			}
		}
		return resultadoCarga;	
	}
	
	//Lista de pagos referenciados obtenidos del archivo
	public List lista(int tipoLista, DepositosRefeBean depositosRefeBean){
		List depositoRefereArchivoLista = null;
		switch (tipoLista) {
	        case  Enum_Lis_DepositosRefere.lisDepositosRef:          
	        	depositoRefereArchivoLista = depositosRefeDAO.listaDepositosReferenciados(depositosRefeBean, tipoLista);
	        break;
		}
		return depositoRefereArchivoLista;
		
	}


	public List depReferenLis(DepositosRefeBean depRefere, int tipoConsulta){

		List listaDep = null;
		listaDep = depositosRefeDAO.listaDepositosNI(depRefere, tipoConsulta);

		return listaDep;		
	}
	
	// Aplicacion de pagos referenciados
	public MensajeTransaccionBean depositoAplicado(DepositosRefeBean depositosRefeBean,int tipoTransaccion, String bancoEstandar){
		MensajeTransaccionBean mensaje = null;
		List<DepositosRefeBean> listaPagos = creaListaPagos(depositosRefeBean);
		mensaje = depositosRefeDAO.aplicaPagosRefMasivo(depositosRefeBean,listaPagos,Enum_Tra_Inserta.grabaTabla,bancoEstandar);
		return mensaje;
	}
	
	
	private List<DepositosRefeBean> creaListaPagos(DepositosRefeBean depRefeBean){
		StringTokenizer tokensBean = new StringTokenizer(depRefeBean.getListaAplicaRef(), "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList<DepositosRefeBean> listaPagos = new ArrayList<DepositosRefeBean>();
		DepositosRefeBean depositosRefeBean;
		try{
			while(tokensBean.hasMoreTokens()){
				depositosRefeBean = new DepositosRefeBean();
				stringCampos = tokensBean.nextToken();

				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				depositosRefeBean.setFolioCargaID(tokensCampos[0]);
				depositosRefeBean.setReferenciaMov(tokensCampos[1]);
				depositosRefeBean.setFechaOperacion(tokensCampos[2]);
				depositosRefeBean.setNumCtaInstit(tokensCampos[3]);
				depositosRefeBean.setMontoMov(tokensCampos[4]);
				depositosRefeBean.setNatMovimiento(tokensCampos[5]);
				depositosRefeBean.setDescripcionMov(tokensCampos[6]);
				depositosRefeBean.setTipoDeposito(tokensCampos[7]);
				depositosRefeBean.setTipoMov(tokensCampos[8]);
				depositosRefeBean.setTipoMoneda(tokensCampos[9]);
				depositosRefeBean.setTipoCanal(tokensCampos[10]);
				depositosRefeBean.setNumTransaccion(tokensCampos[11]);
				depositosRefeBean.setValidacion(tokensCampos[12]);
				depositosRefeBean.setNumVal(tokensCampos[13]);
				depositosRefeBean.setNumIdenArchivo(tokensCampos[14]);
				depositosRefeBean.setNumTran(tokensCampos[15]);
				depositosRefeBean.setFolioCargaID(tokensCampos[16]);
				depositosRefeBean.setInstitucionID(depRefeBean.getInstitucionID());

				listaPagos.add(depositosRefeBean);
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaPagos;
	}
	
	public DepositosRefeBean consulta(int tipoConsulta, DepositosRefeBean depRefeBean){
		DepositosRefeBean depRefe = null;
		switch(tipoConsulta){
		case Enum_Con_Depositos.conValidaciones:
		      depRefe = depositosRefeDAO.Validaciones(depRefeBean, tipoConsulta);
			break;
		case Enum_Con_Depositos.conNumIdArch:
		      depRefe = depositosRefeDAO.ValNumIdArch(depRefeBean, tipoConsulta);
			break;
		}
		return depRefe;
	}

	//-------------------------------------------------------------------

	public void setDepositosRefeDAO(DepositosRefeDAO depositosRefeDAO) {
		this.depositosRefeDAO = depositosRefeDAO;
	}
	public DepositosRefeDAO getDepositosRefeDAO() {
		return depositosRefeDAO;
	}



	public InstitucionesServicio getInstitucionesServicio() {
		return institucionesServicio;
	}



	public void setInstitucionesServicio(InstitucionesServicio institucionesServicio) {
		this.institucionesServicio = institucionesServicio;
	}

}
