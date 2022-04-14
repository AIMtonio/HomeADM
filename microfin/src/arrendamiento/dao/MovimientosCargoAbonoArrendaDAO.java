package arrendamiento.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import arrendamiento.bean.CargoAbonoArrendaBean;
import arrendamiento.bean.TipoMovsCargoAbonoArrendaBean;

public class MovimientosCargoAbonoArrendaDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	Logger log = Logger.getLogger( this.getClass() );

	public MovimientosCargoAbonoArrendaDAO (){
		super();
	}

	/**
	 * Lista de movimientos de cargo y abono de arrendamiento (L=1)
	 * @param cargoAbonoArrendaBean
	 * @param tipoLista
	 * @return
	 */
	public List listaMovsCargoAbono(CargoAbonoArrendaBean cargoAbonoArrendaBean, int tipoLista){
		List movimientos = null;
		try{
			//Query con el Store Procedure
			String query = "call ARRCARGOABONOLIS(?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {	cargoAbonoArrendaBean.getArrendaID(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"MovCargoAbonoArrendaDAO.listaMovsCargoAbono",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRCARGOABONOLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CargoAbonoArrendaBean cargoAbonoArrendaBean = new CargoAbonoArrendaBean();
					cargoAbonoArrendaBean.setArrendaAmortiID(resultSet.getString("ArrendaAmortiID"));
					cargoAbonoArrendaBean.setFechaMovimiento(resultSet.getString("FechaMovimiento"));
					cargoAbonoArrendaBean.setUsuarioMovimiento(resultSet.getString("NombreCompleto"));
					cargoAbonoArrendaBean.setMontoConcepto(resultSet.getString("Monto"));
					cargoAbonoArrendaBean.setNaturaleza(resultSet.getString("Naturaleza"));
					cargoAbonoArrendaBean.setTipoConcepto(resultSet.getString("ConDescripcion"));
					cargoAbonoArrendaBean.setDescriConcepto(resultSet.getString("CargoDescripcion"));
					return cargoAbonoArrendaBean;
				}
			});
			return movimientos = matches.size() > 0 ? matches: null;

		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la lista de movimientos de cargos y abonos de arrendamiento.", e);
			e.printStackTrace();
		}
		return movimientos;
	}



	/**
	 *  DAO para dar de alta los mivimientos de cargo y abono de arrendamiento
	 * @param cargoAbonoArrendaBean
	 * @return
	 */
	public MensajeTransaccionBean altaMovCargoAbono(final CargoAbonoArrendaBean cargoAbonoArrendaBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL ARRCARGOABONOALT(?,?,?,?,?,?,?, ?,?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_ArrendaID", Utileria.convierteLong(cargoAbonoArrendaBean.getArrendaID()));
									sentenciaStore.setInt("Par_ArrendaAmortiID", Utileria.convierteEntero(cargoAbonoArrendaBean.getArrendaAmortiID()));
									sentenciaStore.setInt("Par_TipoConcepto", Utileria.convierteEntero(cargoAbonoArrendaBean.getTipoConcepto()));
									sentenciaStore.setString("Par_Naturaleza", cargoAbonoArrendaBean.getNaturaleza());
									sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(cargoAbonoArrendaBean.getMontoConcepto()));
									sentenciaStore.setString("Par_Descripcion",cargoAbonoArrendaBean.getDescriConcepto());
									sentenciaStore.setInt("Par_UsuarioMovimiento",Utileria.convierteEntero(cargoAbonoArrendaBean.getUsuarioMovimiento()));

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_ConsecutivoCb", Types.INTEGER);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","MovCargoAbonoArrendaDAO.altaMovCargoAbono");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",NumeroTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " MovCargoAbonoArrendaDAO.altaMovCargoAbono");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " MovCargoAbonoArrendaDAO.altaMovCargoAbono");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al registra los movimientos de cargo o abono" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/**
	 * Metodo para grabar los movimientos de la lista
	 * @param listaMovimientos
	 * @return
	 */
	public MensajeTransaccionBean grabaMovimientosCargaAbono(final ArrayList listaMovimientos) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				CargoAbonoArrendaBean iterCargoAbonoArrenda = null;
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					if(!listaMovimientos.isEmpty()) {
						for(int i = 0; i < listaMovimientos.size(); i++){
							iterCargoAbonoArrenda = (CargoAbonoArrendaBean) listaMovimientos.get(i);
							CargoAbonoArrendaBean cargoAbonoArrendaBean = new CargoAbonoArrendaBean();
							cargoAbonoArrendaBean.setArrendaID(iterCargoAbonoArrenda.getArrendaID());
							cargoAbonoArrendaBean.setArrendaAmortiID(iterCargoAbonoArrenda.getArrendaAmortiID());
							cargoAbonoArrendaBean.setTipoConcepto(iterCargoAbonoArrenda.getTipoConcepto());
							cargoAbonoArrendaBean.setDescriConcepto(iterCargoAbonoArrenda.getDescriConcepto());
							cargoAbonoArrendaBean.setUsuarioMovimiento(iterCargoAbonoArrenda.getUsuarioMovimiento());
							cargoAbonoArrendaBean.setMontoConcepto(iterCargoAbonoArrenda.getMontoConcepto());
							cargoAbonoArrendaBean.setNaturaleza(iterCargoAbonoArrenda.getNaturaleza());
							mensajeBean = altaMovCargoAbono(cargoAbonoArrendaBean,  parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero() != 0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					} else {
						throw new Exception("Error en los movimientos de arrendamiento");
					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en grabar movimientos: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}

	/**
	 * DAO para listar los tipos de movimietos de cargo y abono para arrendamiento
	 * @param tipoConsulta
	 * @return
	 */
	public List listaTipMovsCargoAbono(int tipoLista) {
		List tipMovsCargoAbono = null;
		try{
			//Query con el Store Procedure
			String query = "call ARRTIPMOVCARGOABONOLIS(?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {	tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"MovCargoAbonoArrendaDAO.listaTipMovsCargoAbono",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRTIPMOVCARGOABONOLIS(" + Arrays.toString(parametros) + ")");

			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TipoMovsCargoAbonoArrendaBean tipoMovimiento = new TipoMovsCargoAbonoArrendaBean();
					tipoMovimiento.setTipMovCargoAbonoID(resultSet.getString("TipMovCargoAbonoID"));
					tipoMovimiento.setDescripcion(resultSet.getString("Descripcion").toUpperCase());

					return tipoMovimiento;
				}
			});
			return tipMovsCargoAbono = matches.size() > 0 ? matches: null;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la lista de tipos de movimientos de cargo y abono de arrendamiento.", e);
			e.printStackTrace();
		}
		return tipMovsCargoAbono;
	}


	// ----------------------------------- GET y SET -----------------------------------------
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
