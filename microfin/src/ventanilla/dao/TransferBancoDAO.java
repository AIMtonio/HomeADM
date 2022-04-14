package ventanilla.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import contabilidad.dao.PolizaDAO;

import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.bean.TransferBancoBean;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class TransferBancoDAO extends BaseDAO {

	public TransferBancoDAO(){
		super();
	}
	IngresosOperacionesDAO ingresosOperacionesDAO = null;
	PolizaDAO				polizaDAO				= new PolizaDAO();

	public MensajeTransaccionBean altaTransferBanco(final TransferBancoBean transferBancoBean, final List listaDenominaciones,
			final int tipoTransaccion, final String total){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		if(tipoTransaccion==1){
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desTransACaja+": "+Utileria.completaCerosIzquierda(transferBancoBean.getNumCtaInstit(),3));
			ingresosOperacionesBean.setConceptoCon(ingresosOperacionesBean.opeTransferEnvBanco);
		}else{
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descTransCajBanc+": "+Utileria.completaCerosIzquierda(transferBancoBean.getNumCtaInstit(),3));
			ingresosOperacionesBean.setConceptoCon(ingresosOperacionesBean.opeTransferRecBanco);
		}
		int	contador  = 0;
		while(contador <=3){
			contador ++;
			polizaDAO.generaPolizaID(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) >0){

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				try {
					String VarPoliza =ingresosOperacionesBean.getPolizaID();
					transferBancoBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					mensaje = altaTransferenciaBanco(transferBancoBean, tipoTransaccion);
					if(mensaje.getNumero()!=0){
						throw new Exception(mensaje.getDescripcion());
					}

					//VarPoliza = mensaje.getConsecutivoInt();
					IngresosOperacionesBean ingOpeBilletesMonBean = null;
					IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

					ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
					ingresosOperacionesBean.setPolizaID(VarPoliza);
					ingresosOperacionesBean.setSucursalID(transferBancoBean.getSucursalID());
					ingresosOperacionesBean.setCajaID(transferBancoBean.getCajaID());
					ingresosOperacionesBean.setFecha(transferBancoBean.getFecha());
					ingresosOperacionesBean.setMonedaID(transferBancoBean.getMonedaID());
					ingresosOperacionesBean.setInstrumento(transferBancoBean.getCajaID()); //instrumento
					ingresosOperacionesBean.setMontoEnFirme(total);
					ingresosOperacionesBean.setReferenciaMov(transferBancoBean.getNumCtaInstit());
					ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEnvBanco);
					ingresosOperacionesBean.setDesMovCaja(IngresosOperacionesBean.desTransACaja+": "+Utileria.completaCerosIzquierda(transferBancoBean.getNumCtaInstit(),3));

					mensaje = ingresosOperacionesDAO.altaMovsCaja(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensaje.getNumero()!=0){
						throw new Exception(mensaje.getDescripcion());
					}

					ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntEnvBanco);
					mensaje = ingresosOperacionesDAO.altaMovsCaja(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensaje.getNumero()!=0){
						throw new Exception(mensaje.getDescripcion());
					}

					for(int i=0; i<listaDenominaciones.size(); i++){
						String numeroPoliza = "";
						ingOpeBilletesMonBean = (IngresosOperacionesBean)listaDenominaciones.get(i);
						transferBancoBean.setDenominacionID(ingOpeBilletesMonBean.getDenominacionID());
						transferBancoBean.setCantidad(ingOpeBilletesMonBean.getMontoDenominacion());
						// cuando se da de alta la poliza en denominaciones requiere q la referencia lleve el concepto de poliza
						ingresosOperacionesBean.setReferenciaMov(IngresosOperacionesBean.desTransACaja+": "+Utileria.completaCerosIzquierda(transferBancoBean.getNumCtaInstit(),3)); //referencia mov

						mensaje = ingresosOperacionesDAO.altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), false);
						if(mensaje.getNumero()!=0){
							throw new Exception(mensaje.getDescripcion());
						}
						transferBancoBean.setPolizaID(VarPoliza);
						mensaje = altaTransferencia(transferBancoBean, parametrosAuditoriaBean.getNumeroTransaccion(), tipoTransaccion);
						if(mensaje.getNumero()!=0){
							throw new Exception(mensaje.getDescripcion());
						}
					}


					ingresosOperacionesBean.setCantidadMov(total);
					ingresosOperacionesBean.setTotalSalida(total);
					ingresosOperacionesBean.setTotalEntrada("0");
					ingresosOperacionesBean.setOpcionCajaID("0");
					ingresosOperacionesBean.setDenominaciones(transferBancoBean.getDenominaciones());
					ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desTransACaja+": "+Utileria.completaCerosIzquierda(transferBancoBean.getNumCtaInstit(),3));

					mensaje=ingresosOperacionesDAO.validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensaje.getNumero()!=0){
						throw new Exception(mensaje.getDescripcion());
					}

					mensaje.setNombreControl("polizaID");
					mensaje.setConsecutivoString(transferBancoBean.getPolizaID());
					mensaje.setDescripcion("Movimiento de Efectivo Realizado");
				} catch (Exception e) {
					if (mensaje.getNumero() == 0) {
						mensaje.setNumero(999);
					}
					mensaje.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de transefrencia en banco", e);
				}
				return mensaje;
			}
		});
		}else{
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");

		}
		return mensaje;
	}

	//Recepcion de Efectivo de Banco
	public MensajeTransaccionBean recepcionTransferBanco(final TransferBancoBean transferBancoBean, final List listaDenominaciones,
			final int tipoTransaccion, final String total){
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		final IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		if(tipoTransaccion==1){
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desTransACaja+": "+Utileria.completaCerosIzquierda(transferBancoBean.getNumCtaInstit(),3));
			ingresosOperacionesBean.setConceptoCon(ingresosOperacionesBean.opeTransferEnvBanco);
		}else{
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descTransCajBanc+": "+Utileria.completaCerosIzquierda(transferBancoBean.getNumCtaInstit(),3));
			ingresosOperacionesBean.setConceptoCon(ingresosOperacionesBean.opeTransferRecBanco);
		}
		int	contador  = 0;
		while(contador <=3){
			contador ++;
			polizaDAO.generaPolizaID(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				try {
					String VarPoliza =ingresosOperacionesBean.getPolizaID();
					transferBancoBean.setPolizaID(VarPoliza);

					mensaje = recepcionTransferenciaBanco(transferBancoBean, tipoTransaccion);
					if(mensaje.getNumero()!=0){
						throw new Exception(mensaje.getDescripcion());
					}
				//	VarPoliza = mensaje.getConsecutivoInt();
					IngresosOperacionesBean ingOpeBilletesMonBean = null;
					IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

					ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
					ingresosOperacionesBean.setSucursalID(transferBancoBean.getSucursalID());
					ingresosOperacionesBean.setCajaID(transferBancoBean.getCajaID());
					ingresosOperacionesBean.setFecha(transferBancoBean.getFecha());
					ingresosOperacionesBean.setMonedaID(transferBancoBean.getMonedaID());
					ingresosOperacionesBean.setInstrumento(transferBancoBean.getCajaID()); //instrumento


					ingresosOperacionesBean.setMontoEnFirme(total);
					ingresosOperacionesBean.setReferenciaMov(transferBancoBean.getNumCtaInstit());

					ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajRecBanco);
					mensaje = ingresosOperacionesDAO.altaMovsCaja(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensaje.getNumero()!=0){
						throw new Exception(mensaje.getDescripcion());
					}

					ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalRecBanco);
					mensaje = ingresosOperacionesDAO.altaMovsCaja(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensaje.getNumero()!=0){
						throw new Exception(mensaje.getDescripcion());
					}


					for(int i=0; i<listaDenominaciones.size(); i++){
						String numeroPoliza = "";
						ingOpeBilletesMonBean = (IngresosOperacionesBean)listaDenominaciones.get(i);
						//Insertamos  a TRANSFERBANCOS Con ESTATUS R .- Recepcion
						transferBancoBean.setDenominacionID(ingOpeBilletesMonBean.getDenominacionID());
						transferBancoBean.setCantidad(ingOpeBilletesMonBean.getMontoDenominacion());
						mensaje = altaTransferencia(transferBancoBean, parametrosAuditoriaBean.getNumeroTransaccion(), tipoTransaccion);
						if(mensaje.getNumero()!=0){
							throw new Exception(mensaje.getDescripcion());
						}
						// cuando se da de alta la poliza en denominaciones requiere q la referencia lleve el concepto de poliza
						ingresosOperacionesBean.setReferenciaMov(IngresosOperacionesBean.descTransCajBanc+": "+Utileria.completaCerosIzquierda(transferBancoBean.getNumCtaInstit(),3)); //referencia mov
						ingresosOperacionesBean.setDesMovCaja(IngresosOperacionesBean.descTransCajBanc+": "+Utileria.completaCerosIzquierda(transferBancoBean.getNumCtaInstit(),3));

						ingresosOperacionesBean.setPolizaID(VarPoliza);
						mensaje = ingresosOperacionesDAO.altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), false);
						if(mensaje.getNumero()!=0){
							throw new Exception(mensaje.getDescripcion());
						}
					}


					ingresosOperacionesBean.setCantidadMov(total);
					ingresosOperacionesBean.setTotalSalida("0");
					ingresosOperacionesBean.setTotalEntrada(total);
					ingresosOperacionesBean.setOpcionCajaID("0");
					ingresosOperacionesBean.setDenominaciones(transferBancoBean.getDenominaciones());
					ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descTransCajBanc+": "+Utileria.completaCerosIzquierda(transferBancoBean.getNumCtaInstit(),3));

					mensaje=ingresosOperacionesDAO.validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensaje.getNumero()!=0){
						throw new Exception(mensaje.getDescripcion());
					}


					mensaje.setNombreControl("institucionID");
					mensaje.setConsecutivoString(transferBancoBean.getPolizaID());
					mensaje.setDescripcion("Movimiento de Efectivo Realizado");
				} catch (Exception e) {
					if (mensaje.getNumero() == 0) {
						mensaje.setNumero(999);
					}
					mensaje.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en recepcion de transeferencia de banco", e);
				}
				return mensaje;
			}
		});
		}else{
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");

		}
		return mensaje;
	}



	public MensajeTransaccionBean altaTransferencia(final TransferBancoBean transferBancoBean, final Long numTransaccion, final int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TRANSFERBANCOALT (?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("VarTransferID",numTransaccion);
								sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(transferBancoBean.getInstitucionID()));
								sentenciaStore.setString("Par_NumCtaInstit",transferBancoBean.getNumCtaInstit());
								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(transferBancoBean.getSucursalID()));
								sentenciaStore.setInt("Par_CajaID",Utileria.convierteEntero(transferBancoBean.getCajaID()));

								sentenciaStore.setString("Par_MonedaID",transferBancoBean.getMonedaID());
								sentenciaStore.setDouble("Par_Cantidad",Utileria.convierteDoble(transferBancoBean.getCantidad()));
								sentenciaStore.setInt("Par_PolizaID",Utileria.convierteEntero(transferBancoBean.getPolizaID()));
								sentenciaStore.setString("Par_DenominacionID",transferBancoBean.getDenominacionID());
								sentenciaStore.setInt("Par_Estatus",Utileria.convierteEntero(transferBancoBean.getEstatus()));

								sentenciaStore.setString("Par_Fecha",transferBancoBean.getFecha());
								sentenciaStore.setInt("Par_TipoTransaccion",tipoTransaccion);
								sentenciaStore.setString("Par_Referencia",transferBancoBean.getReferencia());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2) + " : " + resultadosStore.getString(4) );
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de transeferencia", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	// Transferencias bancarias
	public MensajeTransaccionBean altaTransferenciaBanco(final TransferBancoBean transferBancoBean, final int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TRANSEFECTIVOPRO (?,?,?,?,?, ?,?,?,?, ?,?, ?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(transferBancoBean.getInstitucionID()));
								sentenciaStore.setString("Par_NumCtaInstit",transferBancoBean.getNumCtaInstit());
								sentenciaStore.setString("Par_Cantidad",transferBancoBean.getCantidad());
								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(transferBancoBean.getSucursalID()));
								sentenciaStore.setInt("Par_CajaID",Utileria.convierteEntero(transferBancoBean.getCajaID()));

								sentenciaStore.setInt("Par_TipoTransaccion",tipoTransaccion);
								sentenciaStore.setString("Par_Referencia",transferBancoBean.getReferencia());
								sentenciaStore.setInt("Par_CentroCostos", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_PolizaID",Utileria.convierteEntero(transferBancoBean.getPolizaID()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de transferencia de banco", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//	Recepción de efectivo en bancos
	public MensajeTransaccionBean recepcionTransferenciaBanco(final TransferBancoBean transferBancoBean, final int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TRANSEFECTIVOPRO (?,?,?,?,?, ?,?,?,?, ?,?, ?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(transferBancoBean.getInstitucionID()));
								sentenciaStore.setString("Par_NumCtaInstit",transferBancoBean.getNumCtaInstit());
								sentenciaStore.setString("Par_Cantidad",transferBancoBean.getCantidad());
								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(transferBancoBean.getSucursalID()));
								sentenciaStore.setInt("Par_CajaID",Utileria.convierteEntero(transferBancoBean.getCajaID()));

								sentenciaStore.setInt("Par_TipoTransaccion",tipoTransaccion);
								sentenciaStore.setString("Par_Referencia",transferBancoBean.getReferencia());
								sentenciaStore.setInt("Par_CentroCostos", Utileria.convierteEntero(transferBancoBean.getcCostos()));
								sentenciaStore.setInt("Par_PolizaID",Utileria.convierteEntero(transferBancoBean.getPolizaID()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de transferencia de banco", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	public IngresosOperacionesDAO getIngresosOperacionesDAO() {
		return ingresosOperacionesDAO;
	}
	public void setIngresosOperacionesDAO(
			IngresosOperacionesDAO ingresosOperacionesDAO) {
		this.ingresosOperacionesDAO = ingresosOperacionesDAO;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}
}
