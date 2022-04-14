package cedes.dao;

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

import cedes.bean.CedesAnclajeBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CedesAnclajeDAO extends BaseDAO{

	public CedesAnclajeDAO(){
		super();
	}

	public MensajeTransaccionBean alta(final CedesAnclajeBean cedesAnclajeBean,final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure

			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CEDESANCLAJEALT(?,?,?,?,?,   ?,?,?,?,?,"
																	  + "?,?,?,?,?,   ?,?,?,?,?,"
																	  + "?,?,?,?,?,	  ?,?,?,?,?,"
																	  + "?,?,?,?,?,	  ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_CedeOriID",Utileria.convierteEntero(cedesAnclajeBean.getCedeOriID()));
									sentenciaStore.setInt("Par_CedeAncID",Utileria.convierteEntero(cedesAnclajeBean.getCedeAncID()));
									sentenciaStore.setDouble("Par_MontoTotal",cedesAnclajeBean.getMontoTotal());
									sentenciaStore.setDouble("Par_MontoTotalAnclar",Utileria.convierteDoble(cedesAnclajeBean.getMonto()));
									sentenciaStore.setInt("Par_Plazo",cedesAnclajeBean.getPlazo());
									sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(cedesAnclajeBean.getTasaBruta()));
									sentenciaStore.setString("Par_FechaAnclaje",Utileria.convierteFecha(cedesAnclajeBean.getFechaInicio()));
									sentenciaStore.setInt("Par_UsuarioAncID",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setInt("Par_SucursalAncID",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setInt("Par_CalculoInteres",Utileria.convierteEntero(cedesAnclajeBean.getCalculoInteres()));

									sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(cedesAnclajeBean.getTasaISR()));
									sentenciaStore.setDouble("Par_TasaNeta",Utileria.convierteDoble(cedesAnclajeBean.getTasaNeta()));
									sentenciaStore.setDouble("Par_InteresGenerado",Utileria.convierteDoble(cedesAnclajeBean.getInteresGenerado()));
									sentenciaStore.setDouble("Par_InteresRecibir",Utileria.convierteDoble(cedesAnclajeBean.getInteresRecibir()));
									sentenciaStore.setDouble("Par_InteresRetener",Utileria.convierteDoble(cedesAnclajeBean.getInteresRetener()));
									sentenciaStore.setDouble("Par_TasaBaseID",Utileria.convierteDoble(cedesAnclajeBean.getTasaBase()));
									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(cedesAnclajeBean.getSobreTasa()));
									sentenciaStore.setDouble("Par_PisoTasa", Utileria.convierteDoble(cedesAnclajeBean.getPisoTasa()));
									sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(cedesAnclajeBean.getTechoTasa()));
									sentenciaStore.setInt("Par_PlazoInvOr",Utileria.convierteEntero(cedesAnclajeBean.getPlazoInvOr()));
									sentenciaStore.setDouble("Par_ValorGat", Utileria.convierteDoble(cedesAnclajeBean.getValorGat()));
									sentenciaStore.setDouble("Par_ValorGatReal", Utileria.convierteDoble(cedesAnclajeBean.getValorGatReal()));

									sentenciaStore.setDouble("Par_NuevaTasa",Utileria.convierteDoble(cedesAnclajeBean.getNuevaTasa()));
									sentenciaStore.setDouble("Par_NuevoIntGen", Utileria.convierteDoble(cedesAnclajeBean.getNuevoInteresGen()));
									sentenciaStore.setDouble("Par_NuevoIntReci", Utileria.convierteDoble(cedesAnclajeBean.getNuevoInteresRec()));
									sentenciaStore.setDouble("Par_TotalRecibir", Utileria.convierteDoble(cedesAnclajeBean.getGranTotal()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESANCLAJEALT "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CedesAnclajeDAO.alta");
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
							throw new Exception(Constantes.MSG_ERROR + " .CedesAnclajeDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de anclajede CEDE" + e);
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





	public CedesAnclajeBean consultaPrincipal(CedesAnclajeBean cedesAnclajeBean, int tipoConsulta){
		String query = "call CEDESANCLAJECON(?,?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(cedesAnclajeBean.getCedeAnclajeID()),
								Utileria.convierteEntero(cedesAnclajeBean.getCedeOriID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CedesAnclajeDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESANCLAJECON(" + Arrays.toString(parametros) + ")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CedesAnclajeBean cedesAnclajeBean = new CedesAnclajeBean();

					cedesAnclajeBean.setMonto(resultSet.getString("Monto"));
					cedesAnclajeBean.setTasaFija(Utileria.convierteDoble(resultSet.getString("TasaFija")));
					cedesAnclajeBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
					cedesAnclajeBean.setPlazoOriginal(resultSet.getString("PlazoOriginal"));
					cedesAnclajeBean.setTasaISR(resultSet.getString("TasaISR"));

					cedesAnclajeBean.setInteresRetener(resultSet.getString("InteresRetener"));
					cedesAnclajeBean.setPlazo(Integer.valueOf(resultSet.getString("Plazo")));
					cedesAnclajeBean.setTasaNeta(resultSet.getString("TasaNeta"));
					cedesAnclajeBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
					cedesAnclajeBean.setFechaInicio(resultSet.getString("FechaInicio"));

					cedesAnclajeBean.setValorGat(resultSet.getString("ValorGat"));
					cedesAnclajeBean.setValorGatReal(resultSet.getString("ValorGatReal"));
					cedesAnclajeBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					cedesAnclajeBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
					cedesAnclajeBean.setTasaBase(resultSet.getString("TasaBase"));

					cedesAnclajeBean.setSobreTasa(resultSet.getString("SobreTasa"));
					cedesAnclajeBean.setPisoTasa(resultSet.getString("PisoTasa"));
					cedesAnclajeBean.setTechoTasa(resultSet.getString("TechoTasa"));
					cedesAnclajeBean.setMontOriginal(resultSet.getString("MontoMadre"));
					cedesAnclajeBean.setInteresGeneradoOriginal(resultSet.getString("InteresGeneradoOriginal"));

					cedesAnclajeBean.setInteresRecibirOriginal(resultSet.getString("InteresRecibirOriginal"));
					cedesAnclajeBean.setInteresRetenerOriginal(resultSet.getString("IntReteM"));
					cedesAnclajeBean.setPlazoInvOr(resultSet.getString("PlazoM"));
					cedesAnclajeBean.setTipoCedeID(Utileria.completaCerosIzquierda(resultSet.getString("TipoCedeID"), 5));
					cedesAnclajeBean.setTasaOriginal(resultSet.getString("TasaOriginal"));

					cedesAnclajeBean.setTasaBaseOriginal(resultSet.getString("TasaBaseIDOriginal"));
					cedesAnclajeBean.setSobreTasaOr(resultSet.getString("SobreTasaOriginal"));
					cedesAnclajeBean.setPisoTasaOr(resultSet.getString("PisoTasaOriginal"));
					cedesAnclajeBean.setTechoTasaOr(resultSet.getString("TechoTasaOriginal"));
					cedesAnclajeBean.setCalculoInteresMa(resultSet.getString("CalculoIntOriginal"));


					cedesAnclajeBean.setNuevoInteresGen(resultSet.getString("NuevoInteresGenerado"));
					cedesAnclajeBean.setNuevoInteresRec(resultSet.getString("NuevoInteresRecibir"));
					cedesAnclajeBean.setMontoTotal(Utileria.convierteDoble(resultSet.getString("MontoConjunto")));
					cedesAnclajeBean.setGranTotal(resultSet.getString("TotalRecibir"));
					cedesAnclajeBean.setEstatus(resultSet.getString("Estatus"));

					cedesAnclajeBean.setClienteID(resultSet.getString("ClienteID"));
					cedesAnclajeBean.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getLong("CuentaAhoID"), 11));
					cedesAnclajeBean.setMonedaID(resultSet.getString("MonedaID"));
					cedesAnclajeBean.setCedeOriID(Utileria.completaCerosIzquierda(resultSet.getString("CedeOriID"), 10));
					cedesAnclajeBean.setNuevaTasa(resultSet.getString("NuevaTasa"));

				return cedesAnclajeBean;
			}
		});


		return matches.size() > 0 ? (CedesAnclajeBean) matches.get(0) : null;
	}




	public CedesAnclajeBean consultaForanea(CedesAnclajeBean cedesAnclajeBean, int tipoConsulta){
		String query = "call CEDESANCLAJECON(?,?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(cedesAnclajeBean.getCedeAnclajeID()),
								Utileria.convierteEntero(cedesAnclajeBean.getCedeOriID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CedesAnclajeDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESANCLAJECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CedesAnclajeBean cedesAnclajeBean = new CedesAnclajeBean();

				if(Integer.valueOf(resultSet.getString(1)) != 0){


					cedesAnclajeBean.setCedeID(Utileria.completaCerosIzquierda(resultSet.getString(1), 10));
					cedesAnclajeBean.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getLong(2), 11));
					cedesAnclajeBean.setTipoCedeID(Utileria.completaCerosIzquierda(resultSet.getString(3), 5));
					cedesAnclajeBean.setFechaInicio(resultSet.getString(4));
					cedesAnclajeBean.setFechaVencimiento(resultSet.getString(5));
					cedesAnclajeBean.setMontoTotal(Utileria.convierteDoble(resultSet.getString(6)));
					cedesAnclajeBean.setPlazo(Integer.valueOf(resultSet.getString(7)));
					cedesAnclajeBean.setTasaBruta(resultSet.getString(8));
					cedesAnclajeBean.setTasaISR(resultSet.getString(9));
					cedesAnclajeBean.setTasaNeta(resultSet.getString(10));
					cedesAnclajeBean.setInteresGenerado(resultSet.getString(11));
					cedesAnclajeBean.setInteresRecibir(resultSet.getString(12));
					cedesAnclajeBean.setInteresRetener(resultSet.getString(13));
					cedesAnclajeBean.setEstatus(resultSet.getString(14));
					cedesAnclajeBean.setClienteID(resultSet.getString(15));
					cedesAnclajeBean.setMonedaID(resultSet.getString(16));
					cedesAnclajeBean.setValorGat(resultSet.getString("ValorGat"));
					cedesAnclajeBean.setValorGatReal(resultSet.getString("ValorGatReal"));
					cedesAnclajeBean.setCedeAnclajeID(Utileria.completaCerosIzquierda(resultSet.getString(19), 10));
					cedesAnclajeBean.setMontOriginal(resultSet.getString("Monto"));
					cedesAnclajeBean.setTasaFija(Utileria.convierteDoble(resultSet.getString("TasaFija")));
					cedesAnclajeBean.setCedeOriID(Utileria.completaCerosIzquierda(resultSet.getString(22), 10));
					cedesAnclajeBean.setFechaAnclaje(resultSet.getString(23));
					cedesAnclajeBean.setMontoAnclar(resultSet.getString("MontoAnclar"));
					cedesAnclajeBean.setTasaBase(resultSet.getString("TasaBase"));
					cedesAnclajeBean.setSobreTasa(resultSet.getString("SobreTasa"));
					cedesAnclajeBean.setPisoTasa(resultSet.getString("PisoTasa"));
					cedesAnclajeBean.setTechoTasa(resultSet.getString("TechoTasa"));
					cedesAnclajeBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
					cedesAnclajeBean.setPlazoInvOr(resultSet.getString("PlazoInvOr"));


				}else{
					cedesAnclajeBean.setCedeID(Utileria.completaCerosIzquierda(resultSet.getString(1), 10));
				}

				return cedesAnclajeBean;
			}
		});


		return matches.size() > 0 ? (CedesAnclajeBean) matches.get(0) : null;
	}


	public CedesAnclajeBean consultaAnclaje(CedesAnclajeBean cedesAnclajeBean, int tipoConsulta){
		String query = "call CEDESANCLAJECON(?,?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(cedesAnclajeBean.getCedeAnclajeID()),
								Utileria.convierteEntero(cedesAnclajeBean.getCedeOriID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CedesAnclajeDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESANCLAJECON(" + Arrays.toString(parametros) + ")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CedesAnclajeBean cedesAnclajeBean = new CedesAnclajeBean();
				cedesAnclajeBean.setCedeID(resultSet.getString("CedeID"));
				cedesAnclajeBean.setCedeOriID(resultSet.getString("CedeOriID"));

				return cedesAnclajeBean;
			}
		});


		return matches.size() > 0 ? (CedesAnclajeBean) matches.get(0) : null;
	}





	//Lista para Principal por Cliente y Estatus
		public List listaPrincipal(CedesAnclajeBean cedesAnclajeBean, int tipoLista){
			String query = "call CEDESANCLAJELIS(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
						cedesAnclajeBean.getCedeAnclajeID(),
						cedesAnclajeBean.getNombreCliente(),
						cedesAnclajeBean.getEstatus(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"CedesAnclajeDAO.listaPrincipal",
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
					};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESANCLAJELIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesAnclajeBean cedesAnclajeBean = new CedesAnclajeBean();
					cedesAnclajeBean.setCedeID(resultSet.getString(1));
					cedesAnclajeBean.setNombreCompleto(resultSet.getString(2));
					return cedesAnclajeBean;

				}
			});
			return matches;
		}




		/* Lista de CEDES con Anclaje */
		public List listaConAnclaje(CedesAnclajeBean cedesAnclajeBean, int tipoLista) {
			//Query con el Store Procedure
			String query = "call CEDESANCLAJELIS(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = { cedesAnclajeBean.getCedeAnclajeID(),
									cedesAnclajeBean.getNombreCliente(),
									cedesAnclajeBean.getEstatus(),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESANCLAJELIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesAnclajeBean cedesAnclajeBean = new CedesAnclajeBean();
					cedesAnclajeBean.setCedeID(resultSet.getString("CedeAncID"));
					cedesAnclajeBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					cedesAnclajeBean.setMonto(resultSet.getString("Monto"));
					cedesAnclajeBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					cedesAnclajeBean.setDescripcion(resultSet.getString("Descripcion"));
					return cedesAnclajeBean;
				}
			});
			return matches;
		}


		/* Lista de CEDES sin Anclaje */
		public List listaSinAnclaje(CedesAnclajeBean cedesAnclajeBean, int tipoLista) {
			//Query con el Store Procedure
			String query = "call CEDESANCLAJELIS(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = { cedesAnclajeBean.getCedeAnclajeID(),
									cedesAnclajeBean.getNombreCliente(),
									cedesAnclajeBean.getEstatus(),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESANCLAJELIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesAnclajeBean cedesAnclajeBean = new CedesAnclajeBean();
					cedesAnclajeBean.setCedeID(resultSet.getString("CedeID"));
					cedesAnclajeBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					cedesAnclajeBean.setMonto(resultSet.getString("Monto"));
					cedesAnclajeBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					cedesAnclajeBean.setDescripcion(resultSet.getString("Descripcion"));
					return cedesAnclajeBean;
				}
			});
			return matches;
		}
}
