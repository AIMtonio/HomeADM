package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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

import tesoreria.bean.ProveedoresBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class ProveedoresDAO extends BaseDAO{

	public ProveedoresDAO() {
		super();
	}

	public static interface fechaVacia{
		String fecha = "1999-01-01";
	}

	final String salidaPantalla="S";

	/**
	 * Alta de proveedores.
	 * @param proveedoresBean : Clase bean con los valores de entrada al SP-PROVEEDORESALT.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean alta(final ProveedoresBean proveedoresBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					proveedoresBean.setTelefono(proveedoresBean.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
					proveedoresBean.setTelefonoCelular(proveedoresBean.getTelefonoCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call PROVEEDORESALT("
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(proveedoresBean.getInstitucionID()));
							sentenciaStore.setString("Par_ApellidoPaterno", proveedoresBean.getApellidoPaterno());
							sentenciaStore.setString("Par_ApellidoMaterno", proveedoresBean.getApellidoMaterno());
							sentenciaStore.setString("Par_PrimerNombre", proveedoresBean.getPrimerNombre());
							sentenciaStore.setString("Par_SegundoNombre", proveedoresBean.getSegundoNombre());

							sentenciaStore.setString("Par_TipoPersona", proveedoresBean.getTipoPersona());
							sentenciaStore.setString("Par_FechaNacimiento", Utileria.convierteFecha(proveedoresBean.getFechaNacimiento()));
							sentenciaStore.setString("Par_CURP", proveedoresBean.getCURP());
							sentenciaStore.setString("Par_RazonSocial", proveedoresBean.getRazonSocial());
							sentenciaStore.setString("Par_RFC", proveedoresBean.getRFC());

							sentenciaStore.setString("Par_RFCpm", proveedoresBean.getRFCpm());
							sentenciaStore.setString("Par_TipoPago", proveedoresBean.getTipoPago());
							sentenciaStore.setString("Par_CuentaClave", proveedoresBean.getCuentaClave());
							sentenciaStore.setString("Par_CuentaComple", proveedoresBean.getCuentaCompleta());
							sentenciaStore.setString("Par_CuentaAntic", proveedoresBean.getCuentaAnticipo());

							sentenciaStore.setString("Par_TipoProveedor", proveedoresBean.getTipoProveedorID());
							sentenciaStore.setString("Par_Correo", proveedoresBean.getCorreo());
							sentenciaStore.setString("Par_Telefono", proveedoresBean.getTelefono());
							sentenciaStore.setString("Par_TelefonoCelular", proveedoresBean.getTelefonoCelular());
							sentenciaStore.setString("Par_ExtTelefonoPart", proveedoresBean.getExtTelefonoPart());

							sentenciaStore.setString("Par_TipoTercero", proveedoresBean.getTipoTerceroID());
							sentenciaStore.setString("Par_TipoOperacion", proveedoresBean.getTipoOperacionID());
							sentenciaStore.setString("Par_PaisResidencia", proveedoresBean.getPaisResidencia());
							sentenciaStore.setString("Par_Nacionalidad", proveedoresBean.getNacionalidad());
							sentenciaStore.setString("Par_NumIDFiscal", proveedoresBean.getIdFiscal());

							sentenciaStore.setInt("Par_PaisNacimiento", Utileria.convierteEntero(proveedoresBean.getPaisNacimiento()));
							sentenciaStore.setInt("Par_EstadoNacimiento", Utileria.convierteEntero(proveedoresBean.getEstadoNacimiento()));
							sentenciaStore.setString("Par_Salida",salidaPantalla);
							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

							//Parametros de Auditoria
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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ProveedoresDAO.alta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ProveedoresDAO.alta");
					} else if(mensajeBean.getNumero()!=0){
						if(mensajeBean.getNumero()==50){ // Error que corresponde a la detección PLD
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Proveedores: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Proveedores: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Modificación de proveedores.
	 * @param proveedoresBean : Clase bean con los valores de entrada al SP-PROVEEDORESALT.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean modifica(final ProveedoresBean proveedoresBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					proveedoresBean.setTelefono(proveedoresBean.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
					proveedoresBean.setTelefonoCelular(proveedoresBean.getTelefonoCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call PROVEEDORESMOD("
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ProveedorID", Utileria.convierteEntero(proveedoresBean.getProveedorID()));
							sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(proveedoresBean.getInstitucionID()));
							sentenciaStore.setString("Par_ApellidoPaterno", proveedoresBean.getApellidoPaterno());
							sentenciaStore.setString("Par_ApellidoMaterno", proveedoresBean.getApellidoMaterno());
							sentenciaStore.setString("Par_PrimerNombre", proveedoresBean.getPrimerNombre());

							sentenciaStore.setString("Par_SegundoNombre", proveedoresBean.getSegundoNombre());
							sentenciaStore.setString("Par_TipoPersona", proveedoresBean.getTipoPersona());
							sentenciaStore.setString("Par_FechaNacimiento", Utileria.convierteFecha(proveedoresBean.getFechaNacimiento()));
							sentenciaStore.setString("Par_CURP", proveedoresBean.getCURP());
							sentenciaStore.setString("Par_RazonSocial", proveedoresBean.getRazonSocial());

							sentenciaStore.setString("Par_RFC", proveedoresBean.getRFC());
							sentenciaStore.setString("Par_RFCpm", proveedoresBean.getRFCpm());
							sentenciaStore.setString("Par_TipoPago", proveedoresBean.getTipoPago());
							sentenciaStore.setString("Par_CuentaClave", proveedoresBean.getCuentaClave());
							sentenciaStore.setString("Par_CuentaComple", proveedoresBean.getCuentaCompleta());

							sentenciaStore.setString("Par_CuentaAntic", proveedoresBean.getCuentaAnticipo());
							sentenciaStore.setString("Par_TipoProveedor", proveedoresBean.getTipoProveedorID());
							sentenciaStore.setString("Par_Correo", proveedoresBean.getCorreo());
							sentenciaStore.setString("Par_Telefono", proveedoresBean.getTelefono());
							sentenciaStore.setString("Par_TelefonoCelular", proveedoresBean.getTelefonoCelular());

							sentenciaStore.setString("Par_ExtTelefonoPart", proveedoresBean.getExtTelefonoPart());
							sentenciaStore.setString("Par_TipoTercero", proveedoresBean.getTipoTerceroID());
							sentenciaStore.setString("Par_TipoOperacion", proveedoresBean.getTipoOperacionID());
							sentenciaStore.setString("Par_PaisResidencia", proveedoresBean.getPaisResidencia());
							sentenciaStore.setString("Par_Nacionalidad", proveedoresBean.getNacionalidad());

							sentenciaStore.setString("Par_NumIDFiscal", proveedoresBean.getIdFiscal());
							sentenciaStore.setInt("Par_PaisNacimiento", Utileria.convierteEntero(proveedoresBean.getPaisNacimiento()));
							sentenciaStore.setInt("Par_EstadoNacimiento", Utileria.convierteEntero(proveedoresBean.getEstadoNacimiento()));
							sentenciaStore.setString("Par_Salida",salidaPantalla);
							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);

							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
							//Parametros de Auditoria
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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ProveedoresDAO.modificacion");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ProveedoresDAO.modificacion");
					} else if(mensajeBean.getNumero()!=0){
						if(mensajeBean.getNumero()==50){ // Error que corresponde a la detección PLD
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificacion de Proveedores: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de Proveedores: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*-------Baja de Proveedores-------*/
	public MensajeTransaccionBean  baja(final ProveedoresBean proveedores) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
	/*--------Baja con SP---------*/
					String query = "call PROVEEDORESBAJ(?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(proveedores.getProveedorID()),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROVEEDORESBAJ(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
										MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
										mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
										mensaje.setDescripcion(resultSet.getString(2));
										mensaje.setNombreControl(resultSet.getString(3));
										return mensaje;

						}
					});

					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de proveedores", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*------------consulta de Proveedores-------------*/
	public ProveedoresBean consultaPrincipal(ProveedoresBean proveedores, int tipoConsulta){
		String query = "call PROVEEDORESCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				proveedores.getProveedorID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ProveedoresDAO.concultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROVEEDORESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProveedoresBean proveedores = new ProveedoresBean();
				proveedores.setProveedorID(resultSet.getString("ProveedorID"));
				proveedores.setInstitucionID(resultSet.getString("InstitucionID"));
				proveedores.setPrimerNombre(resultSet.getString("PrimerNombre"));
				proveedores.setSegundoNombre(resultSet.getString("SegundoNombre"));
				proveedores.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
				proveedores.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
				proveedores.setTipoPersona(resultSet.getString("TipoPersona"));
				proveedores.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
				proveedores.setCURP(resultSet.getString("CURP"));
				proveedores.setRazonSocial(resultSet.getString("RazonSocial"));
				proveedores.setRFC(resultSet.getString("RFC"));
				proveedores.setRFCpm(resultSet.getString("RFCpm"));
				proveedores.setTipoPago(resultSet.getString("TipoPago"));
				proveedores.setCuentaClave(resultSet.getString("CuentaClave"));
				proveedores.setCuentaCompleta(resultSet.getString("CuentaCompleta"));
				proveedores.setCuentaAnticipo(resultSet.getString("CuentaAnticipo"));
				proveedores.setTipoProveedorID(resultSet.getString("TipoProveedor"));
				proveedores.setCorreo(resultSet.getString("Correo"));
				proveedores.setTelefono(resultSet.getString("Telefono"));
				proveedores.setTelefonoCelular(resultSet.getString("TelefonoCelular"));
				proveedores.setEstatus(resultSet.getString("Estatus"));
				proveedores.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
				proveedores.setTipoTerceroID(resultSet.getString("TipoTerceroID"));
				proveedores.setTipoOperacionID(resultSet.getString("TipoOperacionID"));
				proveedores.setPaisResidencia(resultSet.getString("PaisID"));
				proveedores.setNacionalidad(resultSet.getString("Nacionalidad"));
				proveedores.setIdFiscal(resultSet.getString("NumIDFiscal"));
				proveedores.setPaisNacimiento(resultSet.getString("PaisNacimiento"));
				proveedores.setEstadoNacimiento(resultSet.getString("EstadoNacimiento"));
				return proveedores;
			}
		});
		return matches.size() > 0 ? (ProveedoresBean) matches.get(0) : null;
	}


	/*------------consulta de clave bancaria de Proveedores-------------*/
	public ProveedoresBean consultaClabeBancaria(ProveedoresBean proveedores, int tipoConsulta){
		ProveedoresBean proveedoresBean = new ProveedoresBean();
		try{
			String query = "call PROVEEDORESCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					proveedores.getProveedorID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ProveedoresDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROVEEDORESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ProveedoresBean proveedores = new ProveedoresBean();
					proveedores.setCuentaClave(resultSet.getString(1));
					proveedores.setTipoPago(resultSet.getString(2));
					return proveedores;
				}
			});
			proveedoresBean =  matches.size() > 0 ? (ProveedoresBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de clabe bancaria", e);
		}
		return proveedoresBean;
	}

	public List listaAlfanumerica(ProveedoresBean proveedoresBean, int tipoLista){
		String query = "call PROVEEDORESLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					proveedoresBean.getApellidoPaterno(),
					proveedoresBean.getPrimerNombre(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"TipoGasDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROVEEDORESLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProveedoresBean proveedoresBean = new ProveedoresBean();
				proveedoresBean.setProveedorID(resultSet.getString("ProveedorID"));
				proveedoresBean.setRazonSocial(resultSet.getString("Proveedor"));;
				return proveedoresBean;
			}
		});
		return matches;
	}

	public MensajeTransaccionBean altaProvTipoGasto(final ProveedoresBean proveedoresBean) {
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
								String query = "call PROVTIPOGASTOALT(?,?,?, ?,?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

							/*1*/		sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(proveedoresBean.getProveedorID()));
							/*2*/	sentenciaStore.setInt("Par_TipoGastoID",Utileria.convierteEntero(proveedoresBean.getTipoGastoID()));
							/*3*/	sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(proveedoresBean.getSucursal()));


							/*4*/	sentenciaStore.setString("Par_Salida",salidaPantalla);
							/*5*/	sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							/*6*/	sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							/*7*/	sentenciaStore.registerOutParameter("Var_FolioSalida", Types.BIGINT);

							/*8*/	sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
							/*9*/	sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							/*10*/	sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							/*11*/	sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							/*12*/	sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							/*13*/	sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					    	/*14*/	sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta en proveedores tipo gasto", e);
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

	public MensajeTransaccionBean bajaProvTipoGasto(final ProveedoresBean proveedoresBean,final int tipoBaja) {
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
								String query = "call PROVTIPOGASTOBAJ(?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

							/*1*/	sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(proveedoresBean.getProveedorID()));
							/*2*/	sentenciaStore.setInt("Par_TipoGastoID",Utileria.convierteEntero(proveedoresBean.getTipoGastoID()));
							/*3*/	sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(proveedoresBean.getSucursal()));
									sentenciaStore.setInt("Par_TipoBaja",tipoBaja);


							/*4*/	sentenciaStore.setString("Par_Salida",salidaPantalla);
							/*5*/	sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							/*6*/	sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							/*7*/	sentenciaStore.registerOutParameter("Var_FolioSalida", Types.BIGINT);

							/*8*/	sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
							/*9*/	sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							/*10*/	sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							/*11*/	sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							/*12*/	sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							/*13*/	sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					    	/*14*/	sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de proveedores tipo gasto", e);
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

	public List  listaProvPorSucur(ProveedoresBean proveedoresBean,int tipoConsulta){

		List sucursales = null;
		try {
		String query = "call PROVTIPOGASTOCON(?,?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {

				Utileria.convierteEntero(proveedoresBean.getProveedorID()),
				Utileria.convierteEntero(proveedoresBean.getTipoGastoID()),
				Constantes.ENTERO_CERO,//sucursalID
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ProveedoresDao.listaProvPorSucur",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROVTIPOGASTOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProveedoresBean ProvTipoGastoBean = new ProveedoresBean();

				 ProvTipoGastoBean.setProveedorID(resultSet.getString("ProveedorID"));
			     ProvTipoGastoBean.setTipoGastoID(resultSet.getString("TipoGastoID"));
		         ProvTipoGastoBean.setSucursal(resultSet.getString("SucursalID"));


				return ProvTipoGastoBean;
			}
		});
		sucursales = matches;
	}
	  catch (Exception e) {
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de proveedores por sucursal", e);

	}

		return sucursales;

	}
	public List listaTipoTercero(int tipoLista){
		String query = "call CATTIPOTERCEROLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					Constantes.STRING_VACIO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"ProveedoresDAO.listaTipoTerceros",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTIPOTERCEROLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProveedoresBean proveedoresBean = new ProveedoresBean();
				proveedoresBean.setTipoTerceroID(resultSet.getString("Clave"));
				proveedoresBean.setDescripTipoTer(resultSet.getString("Tercero"));;
				return proveedoresBean;
			}
		});
		return matches;
	}

	public List listaTipoOperacion(ProveedoresBean proveedoresBean, int tipoLista){
		String query = "call CATTIPOOPERACIONLIS(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				proveedoresBean.getTipoTerceroID(),
					Constantes.STRING_VACIO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"TipoGasDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTIPOOPERACIONLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProveedoresBean proveedoresBean = new ProveedoresBean();
				proveedoresBean.setTipoOperacionID(resultSet.getString("Clave"));
				proveedoresBean.setDescripTipoOper(resultSet.getString("Operacion"));;
				return proveedoresBean;
			}
		});
		return matches;
	}

	/*------------Tipo Tercero (DIOT)-------------*/
	public ProveedoresBean consultaTipoTercero(ProveedoresBean proveedores, int tipoConsulta){
		String query = "call CATTIPOTERCEROCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				proveedores.getTipoTerceroID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ProveedoresDAO.concultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROVEEDORESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProveedoresBean proveedores = new ProveedoresBean();
				proveedores.setTipoTerceroID(resultSet.getString(1));
				proveedores.setDescripTipoTer(resultSet.getString(2));

				return proveedores;
			}
		});
		return matches.size() > 0 ? (ProveedoresBean) matches.get(0) : null;
	}

	public ProveedoresBean consultaTipoOperacion(ProveedoresBean proveedores, int tipoConsulta){
		String query = "call CATTIPOOPERACIONCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				proveedores.getTipoOperacionID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ProveedoresDAO.concultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTIPOOPERACIONCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProveedoresBean proveedores = new ProveedoresBean();
				proveedores.setTipoOperacionID(resultSet.getString(1));
				proveedores.setDescripTipoOper(resultSet.getString(2));

				return proveedores;
			}
		});
		return matches.size() > 0 ? (ProveedoresBean) matches.get(0) : null;
	}
}
