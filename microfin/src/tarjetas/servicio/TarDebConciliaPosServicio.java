package tarjetas.servicio;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

import tarjetas.bean.TarDebConciEncabezaBean;
import tarjetas.bean.TarDebConciliaDetalleBean;
import tarjetas.bean.TarDebConciliaResumBean;
import tarjetas.dao.TarDebConciliaPosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
 
public class TarDebConciliaPosServicio extends BaseServicio{

	TarDebConciliaPosDAO tarDebConciliaPosDAO = null;
	
	public static interface Enum_Con_ConciliaPOS {
		int consultaFechaPro = 3;
	}
	public static interface Long_ConciliaPOS {
		int longRenglon = 510;
	}
	
	public MensajeTransaccionBean grabaTransaccion (int tipoTransaccion, TarDebConciEncabezaBean tarjetaConciHeaderBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		BufferedReader bufferedReader;
		String renglon;
		String tipoNatContable = "";
		String validaEspVacio = "";
		int numConciliaID = 0; 
		//obtenemos la ruta del archivo para procesarlo
		String nombreArchivo = tarjetaConciHeaderBean.getRuta();
		TarDebConciEncabezaBean tarDebConciConFecha =null;
		
		try {
			bufferedReader = new BufferedReader(new FileReader(nombreArchivo));
			if (bufferedReader != null ){
				while ((renglon = bufferedReader.readLine())!= null && !renglon.trim().equals("")){
						if(renglon.contains("HEADER")){
							//Header
							tarjetaConciHeaderBean.setNomInstituGenera(renglon.substring(11, 31));
							tarjetaConciHeaderBean.setNomInstituRecibe(renglon.substring(32, 52));
							tarjetaConciHeaderBean.setFechaProceso(renglon.substring(72, 78));
							tarjetaConciHeaderBean.setConsecutivo(renglon.substring(92, 98));
							tarjetaConciHeaderBean.setNombreArchivo(new File(nombreArchivo).getName());
							//Validacion para comparar fecha de proceso y consecutivo, evitando que se dupliquen los archivos
							tarDebConciConFecha = tarDebConciliaPosDAO.consultaFechaProceso( Enum_Con_ConciliaPOS.consultaFechaPro , tarjetaConciHeaderBean);
							if (tarDebConciConFecha.getContinuaCarga() == null){
								tarDebConciConFecha.setContinuaCarga(String.valueOf(Constantes.ENTERO_CERO));
							}
							if (Integer.valueOf(tarDebConciConFecha.getContinuaCarga()) == Constantes.ENTERO_CERO){
								//insertar registro 
								mensaje = tarDebConciliaPosDAO.altaEncabezadoConcilia(tarjetaConciHeaderBean);
								numConciliaID = Integer.parseInt(mensaje.getConsecutivoString());
								if ( mensaje.getConsecutivoString().equals(null)) {
									mensaje.setNumero(Integer.valueOf("001"));
									mensaje.setDescripcion("Archivo Invalido. Favor de Verificar.");
									throw new Exception(mensaje.getDescripcion());
								}
							}else{
								mensaje.setNumero(Integer.valueOf("002"));
								mensaje.setDescripcion("El archivo de Conciliación con fecha "+tarjetaConciHeaderBean.getFechaProceso()+ " y consecutivo "+ tarjetaConciHeaderBean.getConsecutivo()+" ya ha sido procesado.");
								throw new Exception(mensaje.getDescripcion());
							}							
						}else if (renglon.contains("TRAILER")){								
							//Trailer
							TarDebConciliaResumBean tarDebResumenBean = new TarDebConciliaResumBean();
							tarDebResumenBean.setConciliaID(String.valueOf(numConciliaID));
							tarDebResumenBean.setNoTotalTransac(renglon.substring(8, 16));
							tarDebResumenBean.setNoTotalVentas(renglon.substring(17, 23));
							tarDebResumenBean.setImporteVtas(Double.parseDouble(renglon.substring(24, 39)) / 100);
							tarDebResumenBean.setNoTotalDisposic(renglon.substring(40, 46));
							tarDebResumenBean.setImporteDisposicion(Double.parseDouble(renglon.substring(47, 62)) / 100);
							tarDebResumenBean.setNoTotalTransDebito(renglon.substring(63, 69));
							tarDebResumenBean.setImporteTransDebito(Double.parseDouble(renglon.substring(70, 85)) / 100);
							tarDebResumenBean.setNoTotalPagosInter(renglon.substring(86, 92));
							tarDebResumenBean.setImportePagosInter(Double.parseDouble(renglon.substring(93, 108)) / 100);
							tarDebResumenBean.setNoTotalDevolucion(renglon.substring(109, 115));
							tarDebResumenBean.setImporteTotalDevol(Double.parseDouble(renglon.substring(116, 131)) / 100);
							tarDebResumenBean.setNoTotalTransCto(renglon.substring(132, 140));
							tarDebResumenBean.setImporteTransCto(Double.parseDouble(renglon.substring(141, 156)) / 100);
							tarDebResumenBean.setNoTotalRepresenta(renglon.substring(157, 163));
							tarDebResumenBean.setImporteRepresenta(Double.parseDouble(renglon.substring(164, 179)) / 100);
							tarDebResumenBean.setNoTotalContracargos(renglon.substring(180, 186));
							tarDebResumenBean.setImporteContracargos(Double.parseDouble(renglon.substring(187, 202)) / 100);
							tarDebResumenBean.setImporteComisiones(Double.parseDouble(renglon.substring(491, 506)) / 100);
							mensaje = tarDebConciliaPosDAO.altaResumenConcilia(tarDebResumenBean);
						}else{
							//Detalles
							if (renglon.length() == Long_ConciliaPOS.longRenglon){

								tipoNatContable = renglon.substring(24,25);
								validaEspVacio  = renglon.substring(50,60);
								
								
								if(!tipoNatContable.trim().equalsIgnoreCase(Constantes.STRING_VACIO) || !validaEspVacio.trim().equalsIgnoreCase(Constantes.STRING_VACIO)){	
										TarDebConciliaDetalleBean tarDebConciliaDetBean = new TarDebConciliaDetalleBean();
										tarDebConciliaDetBean.setConciliaID(String.valueOf(numConciliaID));
										tarDebConciliaDetBean.setBancoEmisor(renglon.substring(0,5));
										tarDebConciliaDetBean.setNumCuenta(renglon.substring(5,24));
										tarDebConciliaDetBean.setNaturalezaConta(renglon.substring(24,25));
										tarDebConciliaDetBean.setMarcaProducto(renglon.substring(25,26));
										
										tarDebConciliaDetBean.setFechaConsumo(renglon.substring(28,34));
										tarDebConciliaDetBean.setFechaProceso(renglon.substring(40,46));
										tarDebConciliaDetBean.setTipoTransaccion(renglon.substring(46,48));
										tarDebConciliaDetBean.setNumLiquidacion(Utileria.convierteEntero(renglon.substring(48,50))+"");
										tarDebConciliaDetBean.setImporteOrigenTrans(Utileria.convierteDoble(renglon.substring(50,63)) / 100 );
										
										tarDebConciliaDetBean.setImporteOrigenCon(Utileria.convierteDoble(renglon.substring(63,76)) / 100);
										tarDebConciliaDetBean.setCodigoMonedaOrigen(renglon.substring(76,79));
										tarDebConciliaDetBean.setImporteDestinoTotal(Utileria.convierteDoble(renglon.substring(79,92)) / 100);
										tarDebConciliaDetBean.setImporteDestinoCon(Utileria.convierteDoble(renglon.substring(92,105)) / 100);
										tarDebConciliaDetBean.setClaveMonedaDestino(renglon.substring(105,108));
										
										tarDebConciliaDetBean.setImporteLiquidado(Utileria.convierteDoble(renglon.substring(115,128)) / 100);
										tarDebConciliaDetBean.setImporteLiquidadoCon(Utileria.convierteDoble(renglon.substring(128,141)) / 100);
										tarDebConciliaDetBean.setClaveMonedaLiqui(renglon.substring(141,144));
										tarDebConciliaDetBean.setClaveComercio(renglon.substring(242,257));
										tarDebConciliaDetBean.setGironegocio(renglon.substring(257,262));
										
										tarDebConciliaDetBean.setNombreComercio(renglon.substring(262,292));
										tarDebConciliaDetBean.setPaisOrigen(renglon.substring(332,335));
										tarDebConciliaDetBean.setRfcComercio(renglon.substring(365,378));
										tarDebConciliaDetBean.setNumeroFuente(renglon.substring(380,385));
										tarDebConciliaDetBean.setNumAutorizacion(renglon.substring(385,391));
										
										tarDebConciliaDetBean.setBancoReceptor(renglon.substring(391,396));
										tarDebConciliaDetBean.setReferenciaTrans(renglon.substring(396,419));
										tarDebConciliaDetBean.setFiidEmisor(renglon.substring(449,453));
										tarDebConciliaDetBean.setFiidAdquiriente(renglon.substring(483,487));
										mensaje = tarDebConciliaPosDAO.altaDetallesConcilia(tarDebConciliaDetBean);
								}
							}else{
								mensaje.setNumero(Integer.valueOf("003"));
								mensaje.setDescripcion("Archivo Invalido. Formato Incorrecto.");
								throw new Exception(mensaje.getDescripcion());
							}
						}
				}
			}else{
				mensaje.setNumero(Integer.valueOf("004"));
				mensaje.setDescripcion("El archivo esta vacio.");
				throw new Exception(mensaje.getDescripcion());
			}
			mensaje.setNumero(Integer.valueOf("000"));
			mensaje.setDescripcion("Archivo de Conciliacion Procesado Correctamente.");	
			bufferedReader.close();
		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en leer archivo de tesoreria movimientos de conciliacion Tarjeta Debito.");
		}
		return mensaje;
	}
	
	public TarDebConciliaPosDAO getTarDebConciliaPosDAO() {
		return tarDebConciliaPosDAO;
	}

	public void setTarDebConciliaPosDAO(TarDebConciliaPosDAO tarDebConciliaPosDAO) {
		this.tarDebConciliaPosDAO = tarDebConciliaPosDAO;
	}	
}
