package tarjetas.servicio;

import java.util.List;

import tarjetas.bean.TarDebConciEncabezaBean;
import tarjetas.dao.TarDebConciliaMovsDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TarDebConciliaMovsServicio extends BaseServicio{

	TarDebConciliaMovsDAO tarDebConciliaMovsDAO = null;
	
	public TarDebConciliaMovsServicio(){
		super();
	}
	
	public static interface Enum_Tra_Movs{
		int concilia	= 1;
		int fraude 		= 2;
	}
	public MensajeTransaccionBean grabaTransaccion(TarDebConciEncabezaBean tardebEncabezaBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String cadena = "";
		String[] cadenaSplit;
		
		if( tardebEncabezaBean.getListMovConcilia() != null ){
			List<String> listaConciliados = tardebEncabezaBean.getListMovConcilia();
			if(!listaConciliados.isEmpty()){
				for(int i=0; i<listaConciliados.size(); i++){
					cadena = listaConciliados.get(i);
					
					if (!cadena.isEmpty()){
						cadenaSplit = cadena.split(",");						
						int numMovID = Integer.parseInt(cadenaSplit[0]);
						String tipoTrans = String.valueOf(cadenaSplit[1]);
						String numTarjeta = String.valueOf(cadenaSplit[2].trim());
						int numReferencia = Integer.parseInt(cadenaSplit[3]);
						String montoOpera = String.valueOf(cadenaSplit[4]).trim();
						
						int folioCargaID = Integer.parseInt(cadenaSplit[5]);
						int detalle = Integer.parseInt(cadenaSplit[6]);
						String tipoTransExt = String.valueOf(cadenaSplit[7]);
						String numTarjetaExt = String.valueOf(cadenaSplit[8].trim());
						int numReferenciaExt = Integer.parseInt(cadenaSplit[9]);
						String montoOperaExt = String.valueOf(cadenaSplit[10]).trim();
						
						if( folioCargaID > 0 ){							
							if( numMovID !=0 || folioCargaID !=0 ){								
								if (numReferencia == numReferenciaExt){									
									if ( numTarjeta.equals(numTarjetaExt)){										
										if (montoOpera.equals(montoOperaExt)){											
											mensaje = tarDebConciliaMovsDAO.alta(numMovID, folioCargaID, detalle, Enum_Tra_Movs.concilia);											
										}else{											
											//Cuando el Monto no coincide se traduce en un fraude y se actualiza su Estatus = F (En conflicto)
											mensaje = tarDebConciliaMovsDAO.alta(numMovID, folioCargaID, detalle, Enum_Tra_Movs.fraude);
											mensaje.setNumero(12);
											mensaje.setDescripcion("Se ha registrado este movimiento como un posible fraude.");
											mensaje.setConsecutivoInt("");
											mensaje.setConsecutivoInt("");
										}
									}else{
										mensaje.setNumero(10);
										mensaje.setDescripcion("El Numero de Tarjeta Interno no coincide con el movimiento Externo. Favor de verificarlo.");
										mensaje.setConsecutivoInt("");
										mensaje.setConsecutivoInt("");
									}
								}else{
									mensaje.setNumero(11);
									mensaje.setDescripcion("El Numero de Autorizacion Interno no coincide con el Externo. Favor de verificarlo.");
									mensaje.setConsecutivoInt("");
									mensaje.setConsecutivoInt("");
								}
							}
						}else{
							mensaje.setNumero(9);
							mensaje.setDescripcion("Asegurese de haber indicado al movimiento externo el n&uacute;mero de conciliaci&oacute;n correctamente.");
							mensaje.setConsecutivoInt("");
							mensaje.setConsecutivoInt("");
						}
					}					
				}
			}else{
				mensaje.setNumero(9);
				mensaje.setDescripcion("No hay datos que conciliar");
				mensaje.setConsecutivoInt("");
				mensaje.setConsecutivoInt("");
			}
		}else{
			mensaje.setNumero(9);
			mensaje.setDescripcion("No hay datos que conciliar");
			mensaje.setConsecutivoInt("");
			mensaje.setConsecutivoInt("");
		}
		
		return mensaje;
	}
	public TarDebConciliaMovsDAO getTarDebConciliaMovsDAO() {
		return tarDebConciliaMovsDAO;
	}

	public void setTarDebConciliaMovsDAO(TarDebConciliaMovsDAO tarDebConciliaMovsDAO) {
		this.tarDebConciliaMovsDAO = tarDebConciliaMovsDAO;
	}	
}