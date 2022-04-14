package aportaciones.dao;

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

import aportaciones.bean.AportacionesAnclajeBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class AportacionesAnclajeDAO extends BaseDAO{

	public AportacionesAnclajeDAO(){
		super();
	}

	public MensajeTransaccionBean alta(final AportacionesAnclajeBean aportacionesAnclajeBean,final int tipoTransaccion) {
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
									String query = "call APORTANCLAJEALT(?,?,?,?,?,   ?,?,?,?,?,"
											+ "?,?,?,?,?,   ?,?,?,?,?,"
											+ "?,?,?,?,?,	  ?,?,?,?,?,"
											+ "?,?,?,?,?,	  ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_AportacionOriID",Utileria.convierteEntero(aportacionesAnclajeBean.getAportacionOriID()));
									sentenciaStore.setInt("Par_AportacionAncID",Utileria.convierteEntero(aportacionesAnclajeBean.getAportacionAncID()));
									sentenciaStore.setDouble("Par_MontoTotal",aportacionesAnclajeBean.getMontoTotal());
									sentenciaStore.setDouble("Par_MontoTotalAnclar",Utileria.convierteDoble(aportacionesAnclajeBean.getMonto()));
									sentenciaStore.setInt("Par_Plazo",aportacionesAnclajeBean.getPlazo());
									sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(aportacionesAnclajeBean.getTasaBruta()));
									sentenciaStore.setString("Par_FechaAnclaje",Utileria.convierteFecha(aportacionesAnclajeBean.getFechaInicio()));
									sentenciaStore.setInt("Par_UsuarioAncID",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setInt("Par_SucursalAncID",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setInt("Par_CalculoInteres",Utileria.convierteEntero(aportacionesAnclajeBean.getCalculoInteres()));

									sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(aportacionesAnclajeBean.getTasaISR()));
									sentenciaStore.setDouble("Par_TasaNeta",Utileria.convierteDoble(aportacionesAnclajeBean.getTasaNeta()));
									sentenciaStore.setDouble("Par_InteresGenerado",Utileria.convierteDoble(aportacionesAnclajeBean.getInteresGenerado()));
									sentenciaStore.setDouble("Par_InteresRecibir",Utileria.convierteDoble(aportacionesAnclajeBean.getInteresRecibir()));
									sentenciaStore.setDouble("Par_InteresRetener",Utileria.convierteDoble(aportacionesAnclajeBean.getInteresRetener()));
									sentenciaStore.setDouble("Par_TasaBaseID",Utileria.convierteDoble(aportacionesAnclajeBean.getTasaBase()));
									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(aportacionesAnclajeBean.getSobreTasa()));
									sentenciaStore.setDouble("Par_PisoTasa", Utileria.convierteDoble(aportacionesAnclajeBean.getPisoTasa()));
									sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(aportacionesAnclajeBean.getTechoTasa()));
									sentenciaStore.setInt("Par_PlazoInvOr",Utileria.convierteEntero(aportacionesAnclajeBean.getPlazoInvOr()));
									sentenciaStore.setDouble("Par_ValorGat", Utileria.convierteDoble(aportacionesAnclajeBean.getValorGat()));
									sentenciaStore.setDouble("Par_ValorGatReal", Utileria.convierteDoble(aportacionesAnclajeBean.getValorGatReal()));

									sentenciaStore.setDouble("Par_NuevaTasa",Utileria.convierteDoble(aportacionesAnclajeBean.getNuevaTasa()));
									sentenciaStore.setDouble("Par_NuevoIntGen", Utileria.convierteDoble(aportacionesAnclajeBean.getNuevoInteresGen()));
									sentenciaStore.setDouble("Par_NuevoIntReci", Utileria.convierteDoble(aportacionesAnclajeBean.getNuevoInteresRec()));
									sentenciaStore.setDouble("Par_TotalRecibir", Utileria.convierteDoble(aportacionesAnclajeBean.getGranTotal()));

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

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTANCLAJEALT "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportacionesAnclajeDAO.alta");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportacionesAnclajeDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de anclaje de Aportacion" + e);
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





	public AportacionesAnclajeBean consultaPrincipal(AportacionesAnclajeBean aportacionesAnclajeBean, int tipoConsulta){
		String query = "call APORTANCLAJECON(?,?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(aportacionesAnclajeBean.getAportAnclajeID()),
				Utileria.convierteEntero(aportacionesAnclajeBean.getAportacionOriID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AportacionesAnclajeDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTANCLAJECON(" + Arrays.toString(parametros) + ")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				AportacionesAnclajeBean aportacionesAnclajeBean = new AportacionesAnclajeBean();

				aportacionesAnclajeBean.setMonto(resultSet.getString("Monto"));
				aportacionesAnclajeBean.setTasaFija(Utileria.convierteDoble(resultSet.getString("TasaFija")));
				aportacionesAnclajeBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
				aportacionesAnclajeBean.setPlazoOriginal(resultSet.getString("PlazoOriginal"));
				aportacionesAnclajeBean.setTasaISR(resultSet.getString("TasaISR"));

				aportacionesAnclajeBean.setInteresRetener(resultSet.getString("InteresRetener"));
				aportacionesAnclajeBean.setPlazo(Integer.valueOf(resultSet.getString("Plazo")));
				aportacionesAnclajeBean.setTasaNeta(resultSet.getString("TasaNeta"));
				aportacionesAnclajeBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
				aportacionesAnclajeBean.setFechaInicio(resultSet.getString("FechaInicio"));

				aportacionesAnclajeBean.setValorGat(resultSet.getString("ValorGat"));
				aportacionesAnclajeBean.setValorGatReal(resultSet.getString("ValorGatReal"));
				aportacionesAnclajeBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				aportacionesAnclajeBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
				aportacionesAnclajeBean.setTasaBase(resultSet.getString("TasaBase"));

				aportacionesAnclajeBean.setSobreTasa(resultSet.getString("SobreTasa"));
				aportacionesAnclajeBean.setPisoTasa(resultSet.getString("PisoTasa"));
				aportacionesAnclajeBean.setTechoTasa(resultSet.getString("TechoTasa"));
				aportacionesAnclajeBean.setMontOriginal(resultSet.getString("MontoMadre"));
				aportacionesAnclajeBean.setInteresGeneradoOriginal(resultSet.getString("InteresGeneradoOriginal"));

				aportacionesAnclajeBean.setInteresRecibirOriginal(resultSet.getString("InteresRecibirOriginal"));
				aportacionesAnclajeBean.setInteresRetenerOriginal(resultSet.getString("IntReteM"));
				aportacionesAnclajeBean.setPlazoInvOr(resultSet.getString("PlazoM"));
				aportacionesAnclajeBean.setTipoAportacionID(Utileria.completaCerosIzquierda(resultSet.getString("TipoAportacionID"), 5));
				aportacionesAnclajeBean.setTasaOriginal(resultSet.getString("TasaOriginal"));

				aportacionesAnclajeBean.setTasaBaseOriginal(resultSet.getString("TasaBaseIDOriginal"));
				aportacionesAnclajeBean.setSobreTasaOr(resultSet.getString("SobreTasaOriginal"));
				aportacionesAnclajeBean.setPisoTasaOr(resultSet.getString("PisoTasaOriginal"));
				aportacionesAnclajeBean.setTechoTasaOr(resultSet.getString("TechoTasaOriginal"));
				aportacionesAnclajeBean.setCalculoInteresMa(resultSet.getString("CalculoIntOriginal"));


				aportacionesAnclajeBean.setNuevoInteresGen(resultSet.getString("NuevoInteresGenerado"));
				aportacionesAnclajeBean.setNuevoInteresRec(resultSet.getString("NuevoInteresRecibir"));
				aportacionesAnclajeBean.setMontoTotal(Utileria.convierteDoble(resultSet.getString("MontoConjunto")));
				aportacionesAnclajeBean.setGranTotal(resultSet.getString("TotalRecibir"));
				aportacionesAnclajeBean.setEstatus(resultSet.getString("Estatus"));

				aportacionesAnclajeBean.setClienteID(resultSet.getString("ClienteID"));
				aportacionesAnclajeBean.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getLong("CuentaAhoID"), 11));
				aportacionesAnclajeBean.setMonedaID(resultSet.getString("MonedaID"));
				aportacionesAnclajeBean.setAportacionOriID(Utileria.completaCerosIzquierda(resultSet.getString("AportacionOriID"), 10));
				aportacionesAnclajeBean.setNuevaTasa(resultSet.getString("NuevaTasa"));

				return aportacionesAnclajeBean;
			}
		});


		return matches.size() > 0 ? (AportacionesAnclajeBean) matches.get(0) : null;
	}




	public AportacionesAnclajeBean consultaForanea(AportacionesAnclajeBean aportacionesAnclajeBean, int tipoConsulta){
		String query = "call APORTANCLAJECON(?,?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(aportacionesAnclajeBean.getAportAnclajeID()),
				Utileria.convierteEntero(aportacionesAnclajeBean.getAportacionOriID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AportacionesAnclajeDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTANCLAJECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				AportacionesAnclajeBean aportacionesAnclajeBean = new AportacionesAnclajeBean();

				if(Integer.valueOf(resultSet.getString(1)) != 0){


					aportacionesAnclajeBean.setAportacionID(Utileria.completaCerosIzquierda(resultSet.getString(1), 10));
					aportacionesAnclajeBean.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getLong(2), 11));
					aportacionesAnclajeBean.setTipoAportacionID(Utileria.completaCerosIzquierda(resultSet.getString(3), 5));
					aportacionesAnclajeBean.setFechaInicio(resultSet.getString(4));
					aportacionesAnclajeBean.setFechaVencimiento(resultSet.getString(5));
					aportacionesAnclajeBean.setMontoTotal(Utileria.convierteDoble(resultSet.getString(6)));
					aportacionesAnclajeBean.setPlazo(Integer.valueOf(resultSet.getString(7)));
					aportacionesAnclajeBean.setTasaBruta(resultSet.getString(8));
					aportacionesAnclajeBean.setTasaISR(resultSet.getString(9));
					aportacionesAnclajeBean.setTasaNeta(resultSet.getString(10));
					aportacionesAnclajeBean.setInteresGenerado(resultSet.getString(11));
					aportacionesAnclajeBean.setInteresRecibir(resultSet.getString(12));
					aportacionesAnclajeBean.setInteresRetener(resultSet.getString(13));
					aportacionesAnclajeBean.setEstatus(resultSet.getString(14));
					aportacionesAnclajeBean.setClienteID(resultSet.getString(15));
					aportacionesAnclajeBean.setMonedaID(resultSet.getString(16));
					aportacionesAnclajeBean.setValorGat(resultSet.getString("ValorGat"));
					aportacionesAnclajeBean.setValorGatReal(resultSet.getString("ValorGatReal"));
					aportacionesAnclajeBean.setAportAnclajeID(Utileria.completaCerosIzquierda(resultSet.getString(19), 10));
					aportacionesAnclajeBean.setMontOriginal(resultSet.getString("Monto"));
					aportacionesAnclajeBean.setTasaFija(Utileria.convierteDoble(resultSet.getString("TasaFija")));
					aportacionesAnclajeBean.setAportacionOriID(Utileria.completaCerosIzquierda(resultSet.getString(22), 10));
					aportacionesAnclajeBean.setFechaAnclaje(resultSet.getString(23));
					aportacionesAnclajeBean.setMontoAnclar(resultSet.getString("MontoAnclar"));
					aportacionesAnclajeBean.setTasaBase(resultSet.getString("TasaBase"));
					aportacionesAnclajeBean.setSobreTasa(resultSet.getString("SobreTasa"));
					aportacionesAnclajeBean.setPisoTasa(resultSet.getString("PisoTasa"));
					aportacionesAnclajeBean.setTechoTasa(resultSet.getString("TechoTasa"));
					aportacionesAnclajeBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
					aportacionesAnclajeBean.setPlazoInvOr(resultSet.getString("PlazoInvOr"));


				}else{
					aportacionesAnclajeBean.setAportacionID(Utileria.completaCerosIzquierda(resultSet.getString(1), 10));
				}

				return aportacionesAnclajeBean;
			}
		});


		return matches.size() > 0 ? (AportacionesAnclajeBean) matches.get(0) : null;
	}


	public AportacionesAnclajeBean consultaAnclaje(AportacionesAnclajeBean aportacionesAnclajeBean, int tipoConsulta){
		String query = "call APORTANCLAJECON(?,?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(aportacionesAnclajeBean.getAportAnclajeID()),
				Utileria.convierteEntero(aportacionesAnclajeBean.getAportacionOriID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AportacionesAnclajeDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTANCLAJECON(" + Arrays.toString(parametros) + ")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				AportacionesAnclajeBean aportacionesAnclajeBean = new AportacionesAnclajeBean();
				aportacionesAnclajeBean.setAportacionID(resultSet.getString("AportacionID"));
				aportacionesAnclajeBean.setAportacionOriID(resultSet.getString("AportacionOriID"));

				return aportacionesAnclajeBean;
			}
		});


		return matches.size() > 0 ? (AportacionesAnclajeBean) matches.get(0) : null;
	}





	//Lista para Principal por Cliente y Estatus
	public List listaPrincipal(AportacionesAnclajeBean aportacionesAnclajeBean, int tipoLista){
		String query = "call APORTANCLAJELIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				aportacionesAnclajeBean.getAportAnclajeID(),
				aportacionesAnclajeBean.getNombreCliente(),
				aportacionesAnclajeBean.getEstatus(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"AportacionesAnclajeDAO.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};


		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTANCLAJELIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AportacionesAnclajeBean aportacionesAnclajeBean = new AportacionesAnclajeBean();
				aportacionesAnclajeBean.setAportacionID(resultSet.getString(1));
				aportacionesAnclajeBean.setNombreCompleto(resultSet.getString(2));
				return aportacionesAnclajeBean;

			}
		});
		return matches;
	}




	/* Lista de AportacionS con Anclaje */
	public List listaConAnclaje(AportacionesAnclajeBean aportacionesAnclajeBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call APORTANCLAJELIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { aportacionesAnclajeBean.getAportAnclajeID(),
				aportacionesAnclajeBean.getNombreCliente(),
				aportacionesAnclajeBean.getEstatus(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTANCLAJELIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AportacionesAnclajeBean aportacionesAnclajeBean = new AportacionesAnclajeBean();
				aportacionesAnclajeBean.setAportacionID(resultSet.getString("AportacionAncID"));
				aportacionesAnclajeBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				aportacionesAnclajeBean.setMonto(resultSet.getString("Monto"));
				aportacionesAnclajeBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				aportacionesAnclajeBean.setDescripcion(resultSet.getString("Descripcion"));
				return aportacionesAnclajeBean;
			}
		});
		return matches;
	}


	/* Lista de AportacionS sin Anclaje */
	public List listaSinAnclaje(AportacionesAnclajeBean aportacionesAnclajeBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call APORTANCLAJELIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { aportacionesAnclajeBean.getAportAnclajeID(),
				aportacionesAnclajeBean.getNombreCliente(),
				aportacionesAnclajeBean.getEstatus(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTANCLAJELIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AportacionesAnclajeBean aportacionesAnclajeBean = new AportacionesAnclajeBean();
				aportacionesAnclajeBean.setAportacionID(resultSet.getString("AportacionID"));
				aportacionesAnclajeBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				aportacionesAnclajeBean.setMonto(resultSet.getString("Monto"));
				aportacionesAnclajeBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				aportacionesAnclajeBean.setDescripcion(resultSet.getString("Descripcion"));
				return aportacionesAnclajeBean;
			}
		});
		return matches;
	}

}