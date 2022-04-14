package originacion.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import originacion.bean.DatSocDemogBean;
import originacion.bean.SocDemogViviendaBean;

public class SosDemogViviendaDAO extends BaseDAO{
	public int mensajeExito=0;

	public SosDemogViviendaDAO() {
		super();
	}

	//Graba Limite Quitas
	public MensajeTransaccionBean grabaDatosSocioDemoVivienda(final SocDemogViviendaBean socDemogViviendaBean){
		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensajeResultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				ArrayList listaDetalleGrid = null ;
				String [] arregloProductos = null;

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = altaHisDatosVivienda(socDemogViviendaBean );//ALTA HISTORIAL SOCIODEMOGRAFICOS
					if( mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean = altaDatosVivienda(socDemogViviendaBean, parametrosAuditoriaBean.getNumeroTransaccion());// ALTA SOCIODEMOGRAAFICOS

					if( mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}



				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al grabar datos sociodemograficos de vivienda", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensajeResultado;
	}

	// metodo de alta de datos dependientes economicos



	// metodo de alta de datos  sociodemograficos
	public MensajeTransaccionBean altaDatosVivienda (final SocDemogViviendaBean socDemogViviendaBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call SOCIODEMOVIVIENALT(?,?,?,?,?,?,?,?,?,?,?,?,  ?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_Prospecto",Utileria.convierteEntero(socDemogViviendaBean.getProspectoID() ));
									sentenciaStore.setInt("Par_Cliente",Utileria.convierteEntero(socDemogViviendaBean.getClienteID() ));
									sentenciaStore.setInt("Par_TipoVivienda",Utileria.convierteEntero( socDemogViviendaBean.getTipoViviendaID()));
									sentenciaStore.setString("Par_ConDrenaje", socDemogViviendaBean.getConDrenaje());
									sentenciaStore.setString("Par_ConElectricidad",socDemogViviendaBean.getConElectricidad());
									sentenciaStore.setString("Par_ConAgua",socDemogViviendaBean.getConAgua());
									sentenciaStore.setString("Par_ConGas",socDemogViviendaBean.getConGas());
									sentenciaStore.setString("Par_ConPavimento",socDemogViviendaBean.getConPavimento());
									sentenciaStore.setInt("Par_TipoMaterial",Utileria.convierteEntero( socDemogViviendaBean.getTipoMaterialID()));
									sentenciaStore.setDouble("Par_ValorVivienda",Utileria.convierteDoble(socDemogViviendaBean.getValorVivienda()));
									sentenciaStore.setString("Par_Descripcion",socDemogViviendaBean.getDescripcion());
									sentenciaStore.setInt("Par_TiempoHabitarDom",Utileria.convierteEntero( socDemogViviendaBean.getTiempoHabitarDom()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de datos de vivienda", e);
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


	//alta a historial de datos sociodemograficos
	public MensajeTransaccionBean altaHisDatosVivienda (final SocDemogViviendaBean socDemogViviendaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call HISSOCIODEMOVIVALT(?,?, ?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_Prospecto",Utileria.convierteEntero(socDemogViviendaBean.getProspectoID()));
									sentenciaStore.setInt("Par_Cliente",Utileria.convierteEntero(socDemogViviendaBean.getClienteID()));

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
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en ata historica de datos de vivienda", e);
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




	public SocDemogViviendaBean consultaPrincipal(SocDemogViviendaBean socDemogViviendaBean, int tipoConsulta) {
		SocDemogViviendaBean socDemogViviendaResulBean = null;
		try {
			// Query con el Store Procedure
			String query = "call SOCIODEMOVIVIENCON("
					+ "?,?,?,?,?,      "
					+ "?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(socDemogViviendaBean.getProspectoID()),
					Utileria.convierteEntero(socDemogViviendaBean.getClienteID()),

					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ClienteDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SOCIODEMOVIVIENCON(" + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SocDemogViviendaBean SocDemogVivBean = new SocDemogViviendaBean();
					try{
					SocDemogVivBean.setProspectoID(resultSet.getString("ProspectoID"));
					SocDemogVivBean.setClienteID(resultSet.getString("ClienteID"));
					SocDemogVivBean.setTipoViviendaID(resultSet.getString("TipoViviendaID"));
					SocDemogVivBean.setConDrenaje(resultSet.getString("ConDrenaje"));
					SocDemogVivBean.setConElectricidad(resultSet.getString("ConElectricidad"));
					SocDemogVivBean.setConAgua(resultSet.getString("ConAgua"));
					SocDemogVivBean.setConGas(resultSet.getString("ConGas"));
					SocDemogVivBean.setConPavimento(resultSet.getString("ConPavimento"));
					SocDemogVivBean.setTipoMaterialID(resultSet.getString("TipoMaterialID"));
					SocDemogVivBean.setValorVivienda(resultSet.getString("ValorVivienda"));
					SocDemogVivBean.setDescripcion(resultSet.getString("ViviendaDesc"));
					SocDemogVivBean.setTiempoHabitarDom(resultSet.getString("TiempoHabitarDom"));
					} catch(Exception ex){
						ex.printStackTrace();
					}

					return SocDemogVivBean;
				}
			});

			socDemogViviendaResulBean = matches.size() > 0 ? (SocDemogViviendaBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en consulta principal de dato sociodemografico de vivienda", e);
		}
		return socDemogViviendaResulBean;
	}

 /* Lista de tipo de material de vivienda  */
  	public List listaTiposMaterVivienda(SocDemogViviendaBean socDemogViviendaBean, int tipoLista){
		List listaResultado=null;
		try{
			String query = "call TIPOMATERIALVIVLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {

					Utileria.convierteEntero(socDemogViviendaBean.getTipoMaterialID()),
					Constantes.STRING_VACIO,
					tipoLista,


					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOMATERIALVIVLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SocDemogViviendaBean datSocDemVivBean = new SocDemogViviendaBean();

					datSocDemVivBean.setTipoMaterialID(resultSet.getString("TipoMaterialID"));
					datSocDemVivBean.setDescripMaterial(resultSet.getString("Descripcion"));



					return datSocDemVivBean;

				}
			});
			listaResultado = matches;
		}
		catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de tipos de materiales de vivienda", e);
		}
		return listaResultado;
	}// fin lista tipos material de vivienda



  	 /* Lista de tipo  de vivienda  */
  	public List listaTiposVivienda(SocDemogViviendaBean socDemogViviendaBean, int tipoLista){
		List listaResultado=null;
		try{
			String query = "call TIPOVIVIENDALIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {

					Utileria.convierteEntero(socDemogViviendaBean.getTipoViviendaID()),
					Constantes.STRING_VACIO,
					tipoLista,


					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOVIVIENDALIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SocDemogViviendaBean datSocDemVivBean = new SocDemogViviendaBean();

					datSocDemVivBean.setTipoViviendaID(resultSet.getString("TipoViviendaID"));
					datSocDemVivBean.setDescripVivienda(resultSet.getString("Descripcion"));



					return datSocDemVivBean;

				}
			});
			listaResultado = matches;
		}
		catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de tipos de vivienda", e);
		}
		return listaResultado;
	}// fin lista tipos de vivienda



}//cierra llave  fin de la clase
