package inversiones.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import herramientas.Constantes;
import herramientas.Utileria;
import inversiones.bean.BeneficiariosInverBean;

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

import inversiones.bean.BeneficiariosInverBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;

public class BeneficiariosInverDAO extends BaseDAO{

	public BeneficiariosInverDAO() {
		super();
	}

	private final static String salidaPantalla = "S";
	ParametrosSesionBean parametrosSesionBean;
	// ------------------ Transacciones ------------------------------------------

	/* Alta del beneficiarios*/
	public MensajeTransaccionBean altaBeneficiario(final BeneficiariosInverBean beneficiariosInverBean) {
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
									String query = "call BENEFICIARIOSINVERALT(" +
										"?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,? );";//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_BeneInverID", Utileria.convierteEntero(beneficiariosInverBean.getBeneInverID()));
									sentenciaStore.setInt("Par_InversionID",Utileria.convierteEntero(beneficiariosInverBean.getInversionIDBen()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(beneficiariosInverBean.getNumeroCte()));
									sentenciaStore.setString("Par_Titulo",beneficiariosInverBean.getTitulo());
									sentenciaStore.setString("Par_PrimerNombre",beneficiariosInverBean.getPrimerNombre());

									sentenciaStore.setString("Par_SegundoNombre",beneficiariosInverBean.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNombre",beneficiariosInverBean.getTercerNombre());
									sentenciaStore.setString("Par_PrimerApellido",beneficiariosInverBean.getApellidoPaterno());
									sentenciaStore.setString("Par_SegundoApellido",beneficiariosInverBean.getApellidoMaterno());
									sentenciaStore.setString("Par_FechaNacimiento",beneficiariosInverBean.getFechaNacimiento());

									sentenciaStore.setInt("Par_PaisID", Utileria.convierteEntero(beneficiariosInverBean.getPaisID()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(beneficiariosInverBean.getEstadoID()));
									sentenciaStore.setString("Par_EstadoCivil",beneficiariosInverBean.getEstadoCivil());
									sentenciaStore.setString("Par_Sexo",beneficiariosInverBean.getSexo());
									sentenciaStore.setString("Par_CURP",beneficiariosInverBean.getCurp());

									sentenciaStore.setString("Par_RFC", beneficiariosInverBean.getRfc());
									sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(beneficiariosInverBean.getOcupacionID()));
									sentenciaStore.setString("Par_ClavePuestoID",beneficiariosInverBean.getClavePuestoID());
									sentenciaStore.setInt("Par_TipoIdentiID",Utileria.convierteEntero(beneficiariosInverBean.getTipoIdentiID()));
									sentenciaStore.setString("Par_NumIdentific",beneficiariosInverBean.getNumIdentific());

									sentenciaStore.setString("Par_FecExIden", Utileria.convierteFecha(beneficiariosInverBean.getFecExIden()));
									sentenciaStore.setString("Par_FecVenIden",Utileria.convierteFecha(beneficiariosInverBean.getFecVenIden()));
									sentenciaStore.setString("Par_TelefonoCasa",beneficiariosInverBean.getTelefonoCasa());
									sentenciaStore.setString("Par_TelefonoCelular",beneficiariosInverBean.getTelefonoCelular());
									sentenciaStore.setString("Par_Correo",beneficiariosInverBean.getCorreo());

									sentenciaStore.setString("Par_Domicilio",beneficiariosInverBean.getDomicilio());
									sentenciaStore.setInt("Par_TipoRelacionID", Utileria.convierteEntero(beneficiariosInverBean.getParentescoID()));
									sentenciaStore.setDouble("Par_Porcentaje",Utileria.convierteDoble(beneficiariosInverBean.getPorcentaje()));
									sentenciaStore.setString("Par_TipoBene",beneficiariosInverBean.getBeneficiarioBen());

									sentenciaStore.setString("Par_Salida",salidaPantalla);
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .beneficiariosInverBeanDAO.altabeneficiariosInverBean");
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
							throw new Exception(Constantes.MSG_ERROR + " .beneficiariosInverBeanDAO.altabeneficiariosInverBean");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro del Beneficiario" + e);
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

	/* Modificacion del beneficiarios*/
	public MensajeTransaccionBean modificaBeneficiario(final BeneficiariosInverBean beneficiariosInverBean) {
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
									String query = "call BENEFICIARIOSINVERMOD(" +
										"?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,? );";//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_BenefInverID", Utileria.convierteEntero(beneficiariosInverBean.getBeneInverID()));
									sentenciaStore.setInt("Par_InversionID",Utileria.convierteEntero(beneficiariosInverBean.getInversionIDBen()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(beneficiariosInverBean.getNumeroCte()));
									sentenciaStore.setString("Par_Titulo",beneficiariosInverBean.getTitulo());
									sentenciaStore.setString("Par_PrimerNombre",beneficiariosInverBean.getPrimerNombre());

									sentenciaStore.setString("Par_SegundoNombre",beneficiariosInverBean.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNombre",beneficiariosInverBean.getTercerNombre());
									sentenciaStore.setString("Par_PrimerApellido",beneficiariosInverBean.getApellidoPaterno());
									sentenciaStore.setString("Par_SegundoApellido",beneficiariosInverBean.getApellidoMaterno());
									sentenciaStore.setString("Par_FechaNacimiento",beneficiariosInverBean.getFechaNacimiento());

									sentenciaStore.setInt("Par_PaisID", Utileria.convierteEntero(beneficiariosInverBean.getPaisID()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(beneficiariosInverBean.getEstadoID()));
									sentenciaStore.setString("Par_EstadoCivil",beneficiariosInverBean.getEstadoCivil());
									sentenciaStore.setString("Par_Sexo",beneficiariosInverBean.getSexo());
									sentenciaStore.setString("Par_CURP",beneficiariosInverBean.getCurp());

									sentenciaStore.setString("Par_RFC", beneficiariosInverBean.getRfc());
									sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(beneficiariosInverBean.getOcupacionID()));
									sentenciaStore.setString("Par_ClavePuestoID",beneficiariosInverBean.getClavePuestoID());
									sentenciaStore.setInt("Par_TipoIdentiID",Utileria.convierteEntero(beneficiariosInverBean.getTipoIdentiID()));
									sentenciaStore.setString("Par_NumIdentific",beneficiariosInverBean.getNumIdentific());

									sentenciaStore.setString("Par_FecExIden", Utileria.convierteFecha(beneficiariosInverBean.getFecExIden()));
									sentenciaStore.setString("Par_FecVenIden",Utileria.convierteFecha(beneficiariosInverBean.getFecVenIden()));
									sentenciaStore.setString("Par_TelefonoCasa",beneficiariosInverBean.getTelefonoCasa());
									sentenciaStore.setString("Par_TelefonoCelular",beneficiariosInverBean.getTelefonoCelular());
									sentenciaStore.setString("Par_Correo",beneficiariosInverBean.getCorreo());

									sentenciaStore.setString("Par_Domicilio",beneficiariosInverBean.getDomicilio());
									sentenciaStore.setInt("Par_TipoRelacionID", Utileria.convierteEntero(beneficiariosInverBean.getParentescoID()));
									sentenciaStore.setDouble("Par_Porcentaje",Utileria.convierteDoble(beneficiariosInverBean.getPorcentaje()));
									sentenciaStore.setString("Par_TipoBene",beneficiariosInverBean.getBeneficiarioBen());

									sentenciaStore.setString("Par_Salida",salidaPantalla);
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .beneficiariosInverBeanDAO.modificaBeneficiariosInverBean");
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
							throw new Exception(Constantes.MSG_ERROR + " .beneficiariosInverBeanDAO.modificaBeneficiariosInverBean");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la modificacion del Beneficiario" + e);
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


	/* Eliminar beneficiarios*/
	public MensajeTransaccionBean eliminaBeneficiario(final BeneficiariosInverBean beneficiariosInverBean) {
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
									String query = "call BENEFICIARIOSINVERBAJ(" +
										"?,?,?,?,?, ?,?,?,?,?, ?,? );";//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_InversionID",Utileria.convierteEntero(beneficiariosInverBean.getInversionIDBen()));
									sentenciaStore.setInt("Par_BenefInverID", Utileria.convierteEntero(beneficiariosInverBean.getBeneInverID()));

									sentenciaStore.setString("Par_Salida",salidaPantalla);
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .beneficiariosInverBeanDAO.eliminaBeneficiariosInverBean");
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
							throw new Exception(Constantes.MSG_ERROR + " .beneficiariosInverBeanDAO.eliminaBeneficiariosInverBean");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la eliminacion del Beneficiario" + e);
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


	// consulta de beneficiarios
	public BeneficiariosInverBean consultaPrincipal( int tipoConsulta, BeneficiariosInverBean beneficiariosInverBean){
		String query = "call BENEFICIARIOSINVERCON(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
					Utileria.convierteEntero(beneficiariosInverBean.getInversionIDBen()),
					Utileria.convierteEntero(beneficiariosInverBean.getBeneInverID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"BeneficiariosInverDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BENEFICIARIOSINVERCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				BeneficiariosInverBean beneficiariosInver = new BeneficiariosInverBean();
				beneficiariosInver.setClienteID(resultSet.getString("ClienteID"));
				beneficiariosInver.setTitulo(resultSet.getString("Titulo"));
				beneficiariosInver.setPrimerNombre(resultSet.getString("PrimerNombre"));
				beneficiariosInver.setSegundoNombre(resultSet.getString("SegundoNombre"));
				beneficiariosInver.setTercerNombre(resultSet.getString("TercerNombre"));
				beneficiariosInver.setApellidoPaterno(resultSet.getString("PrimerApellido"));
				beneficiariosInver.setApellidoMaterno(resultSet.getString("SegundoApellido"));
				beneficiariosInver.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
				beneficiariosInver.setPaisID(resultSet.getString("PaisID"));
				beneficiariosInver.setEstadoID(resultSet.getString("EstadoID"));

				beneficiariosInver.setEstadoCivil(resultSet.getString("EstadoCivil"));
				beneficiariosInver.setSexo(resultSet.getString("Sexo"));
				beneficiariosInver.setCurp(resultSet.getString("CURP"));
				beneficiariosInver.setRfc(resultSet.getString("RFC"));
				beneficiariosInver.setOcupacionID(resultSet.getString("OcupacionID"));
				beneficiariosInver.setClavePuestoID(resultSet.getString("ClavePuestoID"));
				beneficiariosInver.setTipoIdentiID(resultSet.getString("TipoIdentiID"));
				beneficiariosInver.setNumIdentific(resultSet.getString("NumIdentific"));
				beneficiariosInver.setFecExIden(resultSet.getString("FecExIden"));
				beneficiariosInver.setFecVenIden(resultSet.getString("FecVenIden"));
				beneficiariosInver.setTelefonoCasa(resultSet.getString("TelefonoCasa"));

				beneficiariosInver.setTelefonoCelular(resultSet.getString("TelefonoCelular"));
				beneficiariosInver.setCorreo(resultSet.getString("Correo"));
				beneficiariosInver.setDomicilio(resultSet.getString("Domicilio"));
				beneficiariosInver.setParentescoID(resultSet.getString("TipoRelacionID"));
				beneficiariosInver.setPorcentaje(resultSet.getString("Porcentaje"));
				beneficiariosInver.setBeneficiarioBen(resultSet.getString("Beneficiario"));

				return beneficiariosInver;
			}
		});

		return matches.size() > 0 ? (BeneficiariosInverBean) matches.get(0) : null;
	}


	// -- Lista de BeneficiariosInver --//
	public List listaPrincipal(BeneficiariosInverBean beneficiariosInverBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call BENEFICIARIOSINVERLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(beneficiariosInverBean.getInversionID()),
								beneficiariosInverBean.getNombreCompleto(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BENEFICIARIOSINVERLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				BeneficiariosInverBean beneficiariosInver = new BeneficiariosInverBean();
				beneficiariosInver.setBeneInverID(resultSet.getString(1));
				beneficiariosInver.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return beneficiariosInver;
			}
		});
		return matches;
	}


	public List listaBeneficiarios(BeneficiariosInverBean beneficiariosInverBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call BENEFICIARIOSINVERLIS(?,?,?,?,?,   ?,?,?,?,?);";
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"lista de beneficiarios: "+ beneficiariosInverBean.getInversionID());

		Object[] parametros = {	Utileria.convierteEntero(beneficiariosInverBean.getInversionID()),
								Constantes.STRING_VACIO,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BENEFICIARIOSINVERLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				BeneficiariosInverBean beneficiariosInver = new BeneficiariosInverBean();

				beneficiariosInver.setBeneInverID(resultSet.getString("BenefInverID"));
				beneficiariosInver.setInversionID(resultSet.getString("InversionID"));
				beneficiariosInver.setClienteID(resultSet.getString("ClienteID"));
				beneficiariosInver.setNombreCompleto(resultSet.getString("NombreCompleto"));
				beneficiariosInver.setParentescoID(resultSet.getString("TipoRelacionID"));
				beneficiariosInver.setDescripParentesco(resultSet.getString("DescripParentesco"));
				beneficiariosInver.setPorcentaje(resultSet.getString("Porcentaje"));

				return beneficiariosInver;
			}
		});
		return matches;
	}
	// Hereda los Beneficiarios de una inversion anterior
	public MensajeTransaccionBean heredarBeneficiarios(final BeneficiariosInverBean beneficiariosInverBean){
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
								String query = "call BENEFICIARIOSINVERPRO (?,?,?,?,?, ?,?,?,?,?, ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_InversionID",Utileria.convierteEntero(beneficiariosInverBean.getInversionIDBen()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(beneficiariosInverBean.getClienteIDBen()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									//mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Heredar Beneficiarios de Inversion Anterior", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	// Lista de Inversiones a las que esta relacionado una persona(Requerimiento SEIDO)
	public List listaInversiones(BeneficiariosInverBean beneficiariosInverBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call BENEFICIARIOSINVERLIS(?,?,?,?,?,   ?,?,?,?,?);";

		Object[] parametros = {	Constantes.ENTERO_CERO,
								beneficiariosInverBean.getNombreCompleto(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BENEFICIARIOSINVERLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				BeneficiariosInverBean beneficiariosInver = new BeneficiariosInverBean();

				beneficiariosInver.setClienteID(resultSet.getString("ClienteID"));
				beneficiariosInver.setNombreCompleto(resultSet.getString("NombreCompleto"));
				beneficiariosInver.setInversionID(resultSet.getString("InversionID"));
				beneficiariosInver.setMonto(resultSet.getString("Monto"));
				beneficiariosInver.setPorcentaje(resultSet.getString("Porcentaje"));

				return beneficiariosInver;
			}
		});
		return matches;
	}

	//-----getter y setter
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}



}
