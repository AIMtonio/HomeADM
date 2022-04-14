package soporte.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.SucursalesBean;

public class SucursalesDAO extends BaseDAO{

	public SucursalesDAO() {
		super();
	}

// ------------------ Transacciones ------------------------------------------

	/* Alta de Sucursales */
	public MensajeTransaccionBean altaSucursal(final SucursalesBean sucursal) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					sucursal.setExtTelefonoPart(sucursal.getExtTelefonoPart().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SUCURSALESALT(?,?,?,?,?," +
															"?,?,?,?,?," +
															"?,?,?,?,?," +
															"?,?,?,?,?," +
															"?,?,?,?,?," +
															"?,?,?,?,?," +
															"?,?,?,?,?," +
															"?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(sucursal.getSucursalID()));
							sentenciaStore.setString("Par_NombreSucur", sucursal.getNombreSucurs());
							sentenciaStore.setString("Par_TipoSucurs", sucursal.getTipoSucursal());
							sentenciaStore.setInt("Par_PlazaID", Utileria.convierteEntero(sucursal.getPlazaID()));
							sentenciaStore.setInt("Par_CenCosID", Utileria.convierteEntero(sucursal.getCentroCostoID()));

							sentenciaStore.setDouble("Par_IVA", Utileria.convierteDoble(sucursal.getIVA()));
							sentenciaStore.setDouble("Par_TasaISR", Utileria.convierteDoble(sucursal.getTasaISR()));
							sentenciaStore.setInt("Par_NomGerente", Utileria.convierteEntero(sucursal.getNombreGerente()));
							sentenciaStore.setInt("Par_SubGerente", Utileria.convierteEntero(sucursal.getSubGerente()));
							sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(sucursal.getEstadoID()));

							sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(sucursal.getMunicipioID()));
							sentenciaStore.setString("Par_Calle", sucursal.getCalle());
							sentenciaStore.setString("Par_numero", sucursal.getNumero());
							sentenciaStore.setString("Par_ColoniaID", sucursal.getColoniaID());
							sentenciaStore.setString("Par_CP", sucursal.getCP());

							sentenciaStore.setString("Par_Telefono", sucursal.getTelefono());
							sentenciaStore.setInt("Par_DifHorMatr", Utileria.convierteEntero(sucursal.getDifHorarMatriz()));
							sentenciaStore.setString("Par_FechaSucur", Utileria.convierteFecha(sucursal.getFechaSucursal()));
							sentenciaStore.setString("Par_DirCompl", sucursal.getDirecCompleta());
							sentenciaStore.setString("Par_PoderNotarialGte", sucursal.getPoder());

							sentenciaStore.setString("Par_PoderNotarial", sucursal.getPoderNotarial());
							sentenciaStore.setString("Par_TituloGte", sucursal.getTituloGte());
							sentenciaStore.setString("Par_TituloSubGte", sucursal.getTituloSubGte());
							sentenciaStore.setString("Par_ExtTelefonoPart", sucursal.getExtTelefonoPart());
							sentenciaStore.setString("Par_PromotorCaptaID", sucursal.getPromotorCaptaID());

							sentenciaStore.setString("Par_ClaveSucCNBV", sucursal.getClaveSucCNBV());
							sentenciaStore.setString("Par_ClaveSucOpeCred", sucursal.getClaveSucOpeCred());
							sentenciaStore.setString("Par_Latitud", sucursal.getLatitud());
							sentenciaStore.setString("Par_Longitud", sucursal.getLongitud());
							sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(sucursal.getLocalidadID()));
							sentenciaStore.setString("Par_HoraInicioOper", sucursal.getHoraInicioOper());
							sentenciaStore.setString("Par_HoraFinOper", sucursal.getHoraFinOper());




							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

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
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SucursalesDAO.altaSucursal");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .SucursalesDAO.altaSucursal");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero() == 0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de sucursales", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Modificacion de la sucursal */
	public MensajeTransaccionBean modificaSucursal(final SucursalesBean sucursal) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					sucursal.setExtTelefonoPart(sucursal.getExtTelefonoPart().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SUCURSALESMOD(?,?,?,?,?," +
															"?,?,?,?,?," +
															"?,?,?,?,?," +
															"?,?,?,?,?," +
															"?,?,?,?,?," +
															"?,?,?,?,?," +
															"?,?," +
															"?,?,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(sucursal.getSucursalID()));
							sentenciaStore.setString("Par_NombreSucur", sucursal.getNombreSucurs());
							sentenciaStore.setString("Par_TipoSucurs", sucursal.getTipoSucursal());
							sentenciaStore.setInt("Par_PlazaID", Utileria.convierteEntero(sucursal.getPlazaID()));
							sentenciaStore.setInt("Par_CenCosID", Utileria.convierteEntero(sucursal.getCentroCostoID()));

							sentenciaStore.setDouble("Par_IVA", Utileria.convierteDoble(sucursal.getIVA()));
							sentenciaStore.setDouble("Par_TasaISR", Utileria.convierteDoble(sucursal.getTasaISR()));
							sentenciaStore.setInt("Par_NomGerente", Utileria.convierteEntero(sucursal.getNombreGerente()));
							sentenciaStore.setInt("Par_SubGerente", Utileria.convierteEntero(sucursal.getSubGerente()));
							sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(sucursal.getEstadoID()));

							sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(sucursal.getMunicipioID()));
							sentenciaStore.setString("Par_Calle", sucursal.getCalle());
							sentenciaStore.setString("Par_numero", sucursal.getNumero());
							sentenciaStore.setString("Par_ColoniaID", sucursal.getColoniaID());
							sentenciaStore.setString("Par_CP", sucursal.getCP());

							sentenciaStore.setString("Par_Telefono", sucursal.getTelefono());
							sentenciaStore.setInt("Par_DifHorMatr", Utileria.convierteEntero(sucursal.getDifHorarMatriz()));
							sentenciaStore.setString("Par_DirCompl", sucursal.getDirecCompleta());
							sentenciaStore.setString("Par_PoderNotarialGte", sucursal.getPoder());
							sentenciaStore.setString("Par_PoderNotarial", sucursal.getPoderNotarial());

							sentenciaStore.setString("Par_TituloGte", sucursal.getTituloGte());
							sentenciaStore.setString("Par_TituloSubGte", sucursal.getTituloSubGte());
							sentenciaStore.setString("Par_ExtTelefonoPart", sucursal.getExtTelefonoPart());
							sentenciaStore.setString("Par_PromotorCaptaID", sucursal.getPromotorCaptaID());
							sentenciaStore.setString("Par_ClaveSucCNBV", sucursal.getClaveSucCNBV());

							sentenciaStore.setString("Par_ClaveSucOpeCred", sucursal.getClaveSucOpeCred());
							sentenciaStore.setString("Par_Latitud", sucursal.getLatitud());
							sentenciaStore.setString("Par_Longitud", sucursal.getLongitud());
							sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(sucursal.getLocalidadID()));
							sentenciaStore.setString("Par_HoraInicioOper", sucursal.getHoraInicioOper());
							sentenciaStore.setString("Par_HoraFinOper", sucursal.getHoraFinOper());



							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SucursalesDAO.modificaSucursal");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .SucursalesDAO.modificaSucursal");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero() == 0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de sucursales", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	//consulta de sucursales
	public SucursalesBean consultaPrincipal(int sucursalID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SUCURSALESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	sucursalID,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SucursalesDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUCURSALESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SucursalesBean sucursales = new SucursalesBean();
				sucursales.setSucursalID(Utileria.completaCerosIzquierda(resultSet.getInt("SucursalID"),SucursalesBean.LONGITUD_ID));
				sucursales.setNombreSucurs(resultSet.getString("NombreSucurs"));
				sucursales.setTipoSucursal(resultSet.getString("TipoSucursal"));
				sucursales.setPlazaID(String.valueOf(resultSet.getInt("PlazaID")));
				sucursales.setCentroCostoID(String.valueOf(resultSet.getInt("CentroCostoID")));

				sucursales.setIVA(String.valueOf(resultSet.getFloat("IVA")));
				sucursales.setTasaISR(String.valueOf(resultSet.getFloat("TasaISR")));
				sucursales.setNombreGerente(String.valueOf(resultSet.getInt("NombreGerente")));
				sucursales.setSubGerente(String.valueOf(resultSet.getInt("SubGerente")));
				sucursales.setEstadoID(String.valueOf(resultSet.getInt("EstadoID")));

				sucursales.setMunicipioID(String.valueOf(resultSet.getInt("MunicipioID")));
				sucursales.setCalle(resultSet.getString("Calle"));
				sucursales.setNumero(resultSet.getString("Numero"));
				sucursales.setColonia(resultSet.getString("Colonia"));
				sucursales.setCP(resultSet.getString("CP"));

				sucursales.setTelefono(resultSet.getString("Telefono"));
				sucursales.setDifHorarMatriz(String.valueOf(resultSet.getInt("DifHorarMatriz")));
				sucursales.setDirecCompleta(resultSet.getString("DirecCompleta"));
				sucursales.setFechaSucursal(resultSet.getString("FechaSucursal"));
				sucursales.setPoder(resultSet.getString("PoderNotarialGte"));

				sucursales.setPoderNotarial(resultSet.getString("PoderNotarial"));
				sucursales.setTituloGte(resultSet.getString("TituloGte"));
				sucursales.setTituloSubGte(resultSet.getString("TituloSubGte"));
				sucursales.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
				sucursales.setPromotorCaptaID(resultSet.getString("PromotorCaptaID"));

				sucursales.setClaveSucCNBV(resultSet.getString("ClaveSucCNBV"));
				sucursales.setClaveSucOpeCred(resultSet.getString("ClaveSucOpeCred"));

				sucursales.setLocalidadID(resultSet.getString("LocalidadID"));
				sucursales.setColoniaID(resultSet.getString("ColoniaID"));

				sucursales.setLatitud(resultSet.getString("Latitud"));
				sucursales.setLongitud(resultSet.getString("Longitud"));
				sucursales.setHoraInicioOper(resultSet.getString("HoraInicioOper"));
				sucursales.setHoraFinOper(resultSet.getString("HoraFinOper"));



				return sucursales;

			}
		});
		return matches.size() > 0 ? (SucursalesBean) matches.get(0) : null;

	}

	public SucursalesBean consultaForanea(int sucursalID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SUCURSALESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	sucursalID,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SucursalesDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUCURSALESCON" + Arrays.toString(parametros) +")");
		SucursalesBean sucursales = new SucursalesBean();
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SucursalesBean sucursales = new SucursalesBean();
				sucursales.setSucursalID(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),SucursalesBean.LONGITUD_ID));
				sucursales.setNombreSucurs(resultSet.getString(2));

					return sucursales;

			}
		});
		return matches.size() > 0 ? (SucursalesBean) matches.get(0) : null;

	}

	public SucursalesBean consulaNombreSuc(SucursalesBean sucursal, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SUCURSALESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								sucursal.getNombreSucurs(),
								sucursal.getSucursalID(),
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SucursalesDAO.consultaNombreSuc",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUCURSALESCON(" + Arrays.toString(parametros) +")");
		SucursalesBean sucursales = new SucursalesBean();
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SucursalesBean sucursales = new SucursalesBean();
				sucursales.setNombreSucurs(resultSet.getString(1));
					return sucursales;
			}
		});
		return matches.size() > 0 ? (SucursalesBean) matches.get(0) : null;
	}


	public SucursalesBean consultaRepTicket(SucursalesBean sucursal, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SUCURSALESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	sucursal.getSucursalID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SucursalesDAO.consultaRepTicket",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUCURSALESCON(" + Arrays.toString(parametros) +")");
		SucursalesBean sucursales = new SucursalesBean();
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SucursalesBean sucursales = new SucursalesBean();
				sucursales.setNombreMunicipio(resultSet.getString(1));
				sucursales.setNombreEstado(resultSet.getString("NombreEdo"));
				sucursales.setNombreMunicipio(resultSet.getString("NombreMun"));
				sucursales.setNombreEstado(resultSet.getString("NombreEdo"));
				return sucursales;
			}
		});
		return matches.size() > 0 ? (SucursalesBean) matches.get(0) : null;
	}

	//Lista de sucursales
	public List listaSucursales(SucursalesBean sucursales, int tipoLista) {
		//Query con el Store Procedure
		String query = "call SUCURSALESLIS(?,?,?,?,?,	?,?,?,?);";
		Object[] parametros = {	sucursales.getNombreSucurs(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"SucursalesDAO.listaSucursales",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUCURSALESLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SucursalesBean sucursales = new SucursalesBean();
				sucursales.setSucursalID(String.valueOf(resultSet.getInt(1)));
				sucursales.setNombreSucurs(resultSet.getString(2));
				return sucursales;
			}
		});

		return matches;
	}

	//Lista de sucursales para Combo Box
	public List listaCombo(SucursalesBean sucursales, int tipoLista) {
		//Query con el Store Procedure
		String query = "call SUCURSALESLIS(?,?,?,?,?,	?,?,?,?);";
		Object[] parametros = {	Constantes.STRING_VACIO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SucursalesDAO.listaCombo",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUCURSALESLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SucursalesBean sucursales = new SucursalesBean();
				sucursales.setSucursalID(String.valueOf(resultSet.getInt(1)));
				sucursales.setNombreSucurs(resultSet.getString(2));
				return sucursales;
			}
		});

		return matches;
	}


/* lista de sucursales activas para WS */
	public List listaSucursalWS(int tipoLista){

		List sucursalesLis = null;
		try{
			String query = "call SUCURSALESLIS(?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {	Constantes.STRING_VACIO,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SucursalesDAO.listaSucursalWS",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUCURSALESLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					SucursalesBean sucursales = new SucursalesBean();

					sucursales.setSucursalID(resultSet.getString("SucursalID"));
					sucursales.setNombreSucurs(resultSet.getString("NombreSucurs"));

					return sucursales;
				}
			});

			sucursalesLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de sucursales activas para WS", e);
		}

		return sucursalesLis;
	}// fin de lista para WS



}
