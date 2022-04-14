package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tesoreria.bean.DetallefactprovBean;
import tesoreria.bean.FacturaprovBean;

public class DetallefactprovDAO extends BaseDAO{
	//Variables
	public DetallefactprovDAO() {
		super();
	}

	// Alta de detalle de facturas de proveedor
	public MensajeTransaccionBean bajaDetalleFacturaMasiva(final FacturaprovBean facturaprovBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call DETALLEFACTPROVBAJ(?,?,?,?,?,			"+
																		  "?,?,?,?,?,			"+
																		  "?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(facturaprovBean.getProveedorID()));
								sentenciaStore.setString("Par_NoFactura",facturaprovBean.getNoFactura());


								sentenciaStore.setString("Par_Salida",Constantes.salidaSI );
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",Utileria.convierteLong(facturaprovBean.getNumTransaccion()));
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){

									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la baja de detalle factura masiva", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Alta de detalle de facturas de proveedor
		public MensajeTransaccionBean altaDetalleFacturaMasiva(final DetallefactprovBean detallefactprovBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DETALLEFACTPROVALTPRO(?,?,?,?,?,			"+
																			  "?,?,?,?,?,			"+
																			  "?,?,?,?,?,			"+
																			  "?,?,?,?,?,			"+
																			  "?,?,?,?,?,			"+
																			  "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(detallefactprovBean.getProveedorID()));
									sentenciaStore.setString("Par_NoFactura",detallefactprovBean.getNoFactura());
									sentenciaStore.setInt("Par_CentroCostoID",Utileria.convierteEntero(detallefactprovBean.getCentroCostoID()));
									sentenciaStore.setInt("Par_CenCostoManualID",Utileria.convierteEntero(detallefactprovBean.getCenCostoManualID()));
									sentenciaStore.setInt("Par_TipoGasto",Utileria.convierteEntero(detallefactprovBean.getTipoGastoID()));
									sentenciaStore.setDouble("Par_Cantidad",Utileria.convierteDoble(detallefactprovBean.getCantidad()));

									sentenciaStore.setDouble("Par_PrecioUnit",Utileria.convierteDoble(detallefactprovBean.getPrecioUnitario()));
									sentenciaStore.setDouble("Par_Importe",Utileria.convierteDoble(detallefactprovBean.getImporte()));
									sentenciaStore.setString("Par_Descripc",detallefactprovBean.getDescripcion());
									sentenciaStore.setString("Par_Gravable",detallefactprovBean.getGravable());
									sentenciaStore.setString("Par_GravaCero",detallefactprovBean.getGravaCero());

									sentenciaStore.setString("Par_Fecha",Utileria.convierteFecha(detallefactprovBean.getFechaFactura()));
									sentenciaStore.setLong("Par_Poliza",Utileria.convierteLong(detallefactprovBean.getNoPartidaID()));//usado para mandar el no de poliza al detalle

									sentenciaStore.setString("Par_ProrrateaImp",detallefactprovBean.getProrrateaImp());
									sentenciaStore.setString("Par_PagoAnticipado",detallefactprovBean.getPagoAnticipado());
									sentenciaStore.setInt("Par_TipoPagoAnt", Utileria.convierteEntero(detallefactprovBean.getTipoPagoAnt()));
									sentenciaStore.setInt("Par_EmpleadoID",Utileria.convierteEntero(detallefactprovBean.getNoEmpleadoID()));
									sentenciaStore.setInt("Par_CenCostoAntID",Utileria.convierteEntero(detallefactprovBean.getCenCostoAntID()));

									sentenciaStore.setString("Par_GeneraConta",Constantes.salidaSI);
									sentenciaStore.setString("Par_OrigenProceso","FP");

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI );
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",Utileria.convierteLong(detallefactprovBean.getNumTransaccion()));
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){

										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la modificacion de detalle factura masiva", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	// Alta de detalle de facturas de proveedor
	public MensajeTransaccionBean altaDetalleFactura(final DetallefactprovBean detallefactprovBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call DETALLEFACTPROVALT(?,?,?,?,?,	?,?,?,?,?,"
																	 + "?,?,?,?,?,	?,?,?,?,?,"
																	 + "?,?,?,	?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(detallefactprovBean.getProveedorID()));
								sentenciaStore.setString("Par_NoFactura",detallefactprovBean.getNoFactura());
								sentenciaStore.setInt("Par_CentroCostoID",Utileria.convierteEntero(detallefactprovBean.getCentroCostoID()));
								sentenciaStore.setInt("Par_CenCostoManualID",Utileria.convierteEntero(detallefactprovBean.getCenCostoManualID()));
								sentenciaStore.setInt("Par_TipoGasto",Utileria.convierteEntero(detallefactprovBean.getTipoGastoID()));
								sentenciaStore.setDouble("Par_Cantidad",Utileria.convierteDoble(detallefactprovBean.getCantidad()));

								sentenciaStore.setDouble("Par_PrecioUnit",Utileria.convierteDoble(detallefactprovBean.getPrecioUnitario()));
								sentenciaStore.setDouble("Par_Importe",Utileria.convierteDoble(detallefactprovBean.getImporte()));
								sentenciaStore.setString("Par_Descripc",detallefactprovBean.getDescripcion());
								sentenciaStore.setString("Par_Gravable",detallefactprovBean.getGravable());
								sentenciaStore.setString("Par_GravaCero",detallefactprovBean.getGravaCero());

								sentenciaStore.setString("Par_Fecha",Utileria.convierteFecha(detallefactprovBean.getFechaFactura()));
								sentenciaStore.setLong("Par_Poliza",Utileria.convierteLong(detallefactprovBean.getNoPartidaID()));//usado para mandar el no de poliza al detalle

								sentenciaStore.setString("Par_ProrrateaImp",detallefactprovBean.getProrrateaImp());
								sentenciaStore.setString("Par_PagoAnticipado",detallefactprovBean.getPagoAnticipado());
								sentenciaStore.setInt("Par_TipoPagoAnt", Utileria.convierteEntero(detallefactprovBean.getTipoPagoAnt()));
								sentenciaStore.setInt("Par_EmpleadoID",Utileria.convierteEntero(detallefactprovBean.getNoEmpleadoID()));
								sentenciaStore.setInt("Par_CenCostoAntID",Utileria.convierteEntero(detallefactprovBean.getCenCostoAntID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI );
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",Utileria.convierteLong(detallefactprovBean.getNumTransaccion()));
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){

									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lta de detalle factura ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/*
	public MensajeTransaccionBean bajaDetallePolizaPlantilla(final PolizaBean poliza) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			//Query cons el Store Procedure
			String query = "call DETALLEPOLPLANBAJ(?, ?,?,?,?,?,?);";
			Object[] parametros = {
					poliza.getPolizaID(),

					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"DetallePolizaDAO.bajaDetallePoliza",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()

					};

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
					mensaje.setDescripcion(resultSet.getString(2));
					mensaje.setNombreControl(resultSet.getString(3));
					mensaje.setConsecutivoString(resultSet.getString(4));
					return mensaje;

				}
			});
			return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
		} catch (Exception e) {

			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
		}
		return mensaje;
	}
	*/
	public List listaDetalleFact(DetallefactprovBean detallefactprovBean, int tipoLista){

		String query = "call DETALLEFACTPROVLIS(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								detallefactprovBean.getNoFactura(),
								Utileria.convierteEntero(detallefactprovBean.getProveedorID()),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"DetallePolizaDAO.lista",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEFACTPROVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				DetallefactprovBean detallefactprovBean = new DetallefactprovBean();
				detallefactprovBean.setTipoGastoID(resultSet.getString(1));
				detallefactprovBean.setCantidad(resultSet.getString(2));
				detallefactprovBean.setDescripcion(resultSet.getString(3));
				detallefactprovBean.setPrecioUnitario(resultSet.getString(4));
				detallefactprovBean.setImporte(resultSet.getString(5));
				detallefactprovBean.setGravable(resultSet.getString(6));
				detallefactprovBean.setCentroCostoID(resultSet.getString(7));
				detallefactprovBean.setGravaCero(resultSet.getString(8));
				detallefactprovBean.setDescripcionGT(resultSet.getString(9));
				detallefactprovBean.setTipoPago(resultSet.getString(10));
				detallefactprovBean.setNoPartidaID(resultSet.getString(11));
				detallefactprovBean.setEstatus(resultSet.getString("Estatus"));
				return detallefactprovBean;
			}
		});
		return matches;
	}


	public List listaDetalleImp(DetallefactprovBean detallefactprovBean, int tipoLista){

		String query = "call DETALLEFACTPROVLIS(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								detallefactprovBean.getNoFactura(),
								Utileria.convierteEntero(detallefactprovBean.getProveedorID()),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"DetallePolizaDAO.lista",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEFACTPROVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				DetallefactprovBean detallefactprovBean = new DetallefactprovBean();
				detallefactprovBean.setTipoProveedorID(resultSet.getString(1));
				detallefactprovBean.setImpuestoID(resultSet.getString(2));
				detallefactprovBean.setDescripCorta(resultSet.getString(3));
				detallefactprovBean.setTasa(resultSet.getString(4));
				detallefactprovBean.setGravaRetiene(resultSet.getString(5));
				detallefactprovBean.setBaseCalculo(resultSet.getString(6));
				detallefactprovBean.setImpuestoCalculo(resultSet.getString(7));
				detallefactprovBean.setNoTotalImpuesto(resultSet.getString("NoTotalImpuesto"));
				detallefactprovBean.setConsecutivo(resultSet.getString("Consecutivo"));

				return detallefactprovBean;
			}
		});
		return matches;
	}

	public List listaImporteImp(DetallefactprovBean detallefactprovBean, int tipoLista){

		String query = "call DETALLEFACTPROVLIS(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								detallefactprovBean.getNoFactura(),
								Utileria.convierteEntero(detallefactprovBean.getProveedorID()),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"listaImporteImp.lista",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEFACTPROVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DetallefactprovBean detallefactprovBean = new DetallefactprovBean();
				detallefactprovBean.setImporteImpuesto(resultSet.getString(1));
				detallefactprovBean.setImpuestoID(resultSet.getString(2));


				return detallefactprovBean;
			}
		});
		return matches;
	}



}
