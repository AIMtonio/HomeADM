package credito.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import credito.bean.EsquemaSeguroVidaBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class EsquemaSeguroVidaDAO extends BaseDAO  {

	public EsquemaSeguroVidaDAO() {
		super();
	}


	/*=============================== METODOS ==================================*/

	/* da de alta un esquema de Seguro de Vida para un producto de credito */
	public MensajeTransaccionBean alta(final EsquemaSeguroVidaBean bean, final String esPrimero) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call ESQUEMASEGUROVIDAALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,   ?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);


					sentenciaStore.setInt("Par_ProducCredID", Utileria.convierteEntero(bean.getProductCreditoID()));
					sentenciaStore.setString("Par_TipoPagoSeguro",bean.getTipoPagoSeguro());
					sentenciaStore.setDouble("Par_FactRiesgoSeguro", Utileria.convierteDoble(bean.getFactorRiesgoSeguro()));
					sentenciaStore.setDouble("Par_DescSeguro", Utileria.convierteDoble(bean.getDescuentoSeguro()));
					sentenciaStore.setDouble("Par_MontoPolSegVida", Utileria.convierteDoble(bean.getMontoPolSegVida()));

					sentenciaStore.setString("Par_EsPrimero",esPrimero);

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


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMASEGUROVIDAALT(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
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
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Esquema de Seguro de Vida.", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de alta





	/* metodo para que manda llamar el metodo alta en el cual se llama al sp y se inserta el registro*/
	public MensajeTransaccionBean procesarAlta(final List listaEsquemas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean)transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					EsquemaSeguroVidaBean bean;

					if(listaEsquemas!=null){
						for(int i=0; i<listaEsquemas.size(); i++){
							/* obtenemos un bean de la lista */
							bean = (EsquemaSeguroVidaBean)listaEsquemas.get(i);

							/*Si es el primero eliminara todos los registros de la tabla para insertar todos de nuevo */
							if(i==0){
								mensajeBean = alta(bean, "S");
							}
							else{
								mensajeBean = alta(bean, "N");
							}

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							System.out.println("error dao " + mensajeBean.getDescripcion());

						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en procesa alta de esquema de seguro de vida", e);
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}// fin



	/* Lista esquemas de garantia liquida para un producto de credito (grid) */
	public List listaPorProducCredito(EsquemaSeguroVidaBean bean, int tipoLista) {
		String query = "call ESQUEMASEGUROVIDALIS(?,?,?,?,?,   ?,?,?,?,?);";
		Object[] parametros = {		Utileria.convierteEntero(bean.getProductCreditoID()),
									Utileria.convierteEntero(bean.getEsquemaSeguroID()),
									tipoLista,
									Constantes.ENTERO_CERO,		//	empresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMASEGUROVIDALIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EsquemaSeguroVidaBean bean = new EsquemaSeguroVidaBean();

				bean.setEsquemaSeguroID(resultSet.getString("EsquemaSeguroID"));
				bean.setProductCreditoID(resultSet.getString("ProducCreditoID"));
				bean.setTipoPagoSeguro(resultSet.getString("TipoPagoSeguro"));
				bean.setFactorRiesgoSeguro(resultSet.getString("FactorRiesgoSeguro"));
				bean.setDescuentoSeguro(resultSet.getString("DescuentoSeguro"));
				bean.setMontoPolSegVida(resultSet.getString("MontoPolSegVida"));
				return bean;
			}
		});

		return matches;
	}// fin de lista




	/* Lista esquemas de Seguro de Vida para un producto de creditopara solicitudes de crédito*/
	public List listaComboTipoPago(EsquemaSeguroVidaBean bean, int tipoLista) {
		String query = "call ESQUEMASEGUROVIDALIS(?,?,?,?,?,   ?,?,?,?,?);";
		Object[] parametros = {		Utileria.convierteEntero(bean.getProductoCreditoID()),
									Utileria.convierteEntero(bean.getEsquemaSeguroID()),
									tipoLista,
									Constantes.ENTERO_CERO,		//	empresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMASEGUROVIDALIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EsquemaSeguroVidaBean bean = new EsquemaSeguroVidaBean();

				bean.setEsquemaSeguroID(resultSet.getString("EsquemaSeguroID"));
				bean.setProductoCreditoID(resultSet.getString("ProducCreditoID"));
				bean.setTipoPagoSeguro(resultSet.getString("TipoPagoSeguro"));
				bean.setFactorRiesgoSeguro(resultSet.getString("FactorRiesgoSeguro"));
				bean.setDescuentoSeguro(resultSet.getString("DescuentoSeguro"));
				bean.setMontoPolSegVida(resultSet.getString("MontoPolSegVida"));
				bean.setDescTipPago(resultSet.getString("DescTipPago"));
				return bean;
			}
		});

		return matches;
	}// fin de lista



	/* Lista esquemas de seguro de vida para un producto de credito para alta de créditos */
	public List listaComboTipoPagoCred(EsquemaSeguroVidaBean bean, int tipoLista) {
		String query = "call ESQUEMASEGUROVIDALIS(?,?,?,?,?,   ?,?,?,?,?);";
		Object[] parametros = {		Utileria.convierteEntero(bean.getProducCreditoID()),
									Utileria.convierteEntero(bean.getEsquemaSeguroID()),
									tipoLista,
									Constantes.ENTERO_CERO,		//	empresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMASEGUROVIDALIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EsquemaSeguroVidaBean bean = new EsquemaSeguroVidaBean();

				bean.setEsquemaSeguroID(resultSet.getString("EsquemaSeguroID"));
				bean.setProducCreditoID(resultSet.getString("ProducCreditoID"));
				bean.setTipoPagoSeguro(resultSet.getString("TipoPagoSeguro"));
				bean.setFactorRiesgoSeguro(resultSet.getString("FactorRiesgoSeguro"));
				bean.setDescuentoSeguro(resultSet.getString("DescuentoSeguro"));
				bean.setMontoPolSegVida(resultSet.getString("MontoPolSegVida"));
				bean.setDescTipPago(resultSet.getString("DescTipPago"));
				return bean;
			}
		});

		return matches;
	}// fin de lista



	/* Consulta los datos de un esquema de Seguro de Vida para un producto de credito */
	public EsquemaSeguroVidaBean consultaPrincipal(EsquemaSeguroVidaBean bean, int tipoConsulta) {
		EsquemaSeguroVidaBean esquema = new EsquemaSeguroVidaBean();
		try{
			String query = "call ESQUEMASEGUROVIDACON(?,?, ?,?,?,?,?,   ?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(bean.getProductCreditoID()),
									Utileria.convierteEntero(bean.getEsquemaSeguroID()),
									bean.getTipoPagoSeguro(),

									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EsquemaGarantiaLiqDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMASEGUROVIDACON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaSeguroVidaBean bean = new EsquemaSeguroVidaBean();

					bean.setEsquemaSeguroID(resultSet.getString("EsquemaSeguroID"));
					bean.setProductCreditoID(resultSet.getString("ProducCreditoID"));
					bean.setTipoPagoSeguro(resultSet.getString("TipoPagoSeguro"));
					bean.setFactorRiesgoSeguro(resultSet.getString("FactorRiesgoSeguro"));
					bean.setDescuentoSeguro(resultSet.getString("DescuentoSeguro"));
					bean.setMontoPolSegVida(resultSet.getString("MontoPolSegVida"));

					return bean;
				}
			});
			esquema =  matches.size() > 0 ? (EsquemaSeguroVidaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return esquema;
	}// fin de consulta



	/* Consulta los datos de un esquema de Seguro de Vida para un producto de credito */
	public EsquemaSeguroVidaBean consultaPorTipoPago(EsquemaSeguroVidaBean bean, int tipoConsulta) {
		EsquemaSeguroVidaBean esquema = new EsquemaSeguroVidaBean();

		try{
			String query = "call ESQUEMASEGUROVIDACON(?,?, ?,?,?,?,?,   ?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(bean.getProductCreditoID()),
									Utileria.convierteEntero(bean.getEsquemaSeguroID()),
									bean.getTipoPagoSeguro(),

									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EsquemaSeguroVidaDAO.consultaTipoPago",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMASEGUROVIDACON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaSeguroVidaBean bean = new EsquemaSeguroVidaBean();

					bean.setEsquemaSeguroID(resultSet.getString("EsquemaSeguroID"));
					bean.setProductCreditoID(resultSet.getString("ProducCreditoID"));
					bean.setTipoPagoSeguro(resultSet.getString("TipoPagoSeguro"));
					bean.setFactorRiesgoSeguro(resultSet.getString("FactorRiesgoSeguro"));
					bean.setDescuentoSeguro(resultSet.getString("DescuentoSeguro"));
					bean.setMontoPolSegVida(resultSet.getString("MontoPolSegVida"));

					return bean;
				}
			});
			esquema =  matches.size() > 0 ? (EsquemaSeguroVidaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return esquema;
	}// fin de consulta



	/* Consulta los datos de un esquema de Seguro de Vida para un producto de credito */
	public EsquemaSeguroVidaBean consultaPorTipoPagoCredito(EsquemaSeguroVidaBean bean, int tipoConsulta) {
		EsquemaSeguroVidaBean esquema = new EsquemaSeguroVidaBean();
		try{
			String query = "call ESQUEMASEGUROVIDACON(?,?, ?,?,?,?,?,   ?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(bean.getProducCreditoID()),
									Utileria.convierteEntero(bean.getEsquemaSeguroID()),
									bean.getTipoPagoSeguro(),

									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EsquemaGarantiaLiqDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMASEGUROVIDACON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaSeguroVidaBean bean = new EsquemaSeguroVidaBean();

					bean.setEsquemaSeguroID(resultSet.getString("EsquemaSeguroID"));
					bean.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					bean.setTipoPagoSeguro(resultSet.getString("TipoPagoSeguro"));
					bean.setFactorRiesgoSeguro(resultSet.getString("FactorRiesgoSeguro"));
					bean.setDescuentoSeguro(resultSet.getString("DescuentoSeguro"));
					bean.setMontoPolSegVida(resultSet.getString("MontoPolSegVida"));

					return bean;
				}
			});
			esquema =  matches.size() > 0 ? (EsquemaSeguroVidaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return esquema;
	}// fin de consulta





	/* Consulta los datos de un esquema de Seguro de Vida para un producto de credito */
	public EsquemaSeguroVidaBean consultaForanea(EsquemaSeguroVidaBean bean, int tipoConsulta) {
		EsquemaSeguroVidaBean esquema = new EsquemaSeguroVidaBean();

		try{
			String query = "call ESQUEMASEGUROVIDACON(?,?, ?,?,?,?,?,   ?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(bean.getProductoCreditoID()),
									Utileria.convierteEntero(bean.getEsquemaSeguroID()),
									bean.getTipoPagoSeguro(),

									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EsquemaSeguroVidaDAO.consultaTipoPago",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMASEGUROVIDACON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaSeguroVidaBean bean = new EsquemaSeguroVidaBean();

					bean.setEsquemaSeguroID(resultSet.getString("EsquemaSeguroID"));
					bean.setProductoCreditoID(resultSet.getString("ProducCreditoID"));
					bean.setTipoPagoSeguro(resultSet.getString("TipoPagoSeguro"));
					bean.setFactorRiesgoSeguro(resultSet.getString("FactorRiesgoSeguro"));
					bean.setDescuentoSeguro(resultSet.getString("DescuentoSeguro"));
					bean.setMontoPolSegVida(resultSet.getString("MontoPolSegVida"));

					return bean;
				}
			});
			esquema =  matches.size() > 0 ? (EsquemaSeguroVidaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return esquema;
	}// fin de consulta





	/* Metodo para dar de baja todos los esquemas de Seguro de Vida para un producto de credito */
	public MensajeTransaccionBean baja(final EsquemaSeguroVidaBean bean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

	mensaje = (MensajeTransaccionBean)transactionTemplate.execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call ESQUEMASEGUROVIDABAJ(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(bean.getProductCreditoID()));
					sentenciaStore.setString("Par_TipoPagoSeguro",bean.getTipoPagoSeguro());
					sentenciaStore.setInt("Par_EsquemaSeguroID", Utileria.convierteEntero(bean.getEsquemaSeguroID()));

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
					sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
					sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
					sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
					sentenciaStore.setString("Aud_ProgramaID","ClienteArchivosDAO");
					sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
					sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMASEGUROVIDABAJ(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
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
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de esquemas de seguro de vida.", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de metodo baja





	/* Metodo para dar de baja y actualizar todos los esquemas de seguro de vida para un producto de credito */
	public MensajeTransaccionBean actualiza(final EsquemaSeguroVidaBean bean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

	mensaje = (MensajeTransaccionBean)transactionTemplate.execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call ESQUEMASEGUROVIDAACT(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(bean.getProductCreditoID()));
					sentenciaStore.setString("Par_TipoPagoSeguro", Constantes.STRING_VACIO);
					sentenciaStore.setInt("Par_EsquemaSeguroID", Constantes.ENTERO_CERO);
					sentenciaStore.setString("Par_ReqSeguroVida", bean.getReqSeguroVida());
					sentenciaStore.setString("Par_TipPago",bean.getTipoPagoSeguro());
					sentenciaStore.setDouble("Par_FactRiesSeg", Utileria.convierteDoble(bean.getFactorRiesgoSeguro()));
					sentenciaStore.setDouble("Par_DescuentoSeg", Utileria.convierteDoble(bean.getDescuentoSeguro()));
					sentenciaStore.setDouble("Par_MontoPolSegVida", Utileria.convierteDoble(bean.getMontoPolSegVida()));
					sentenciaStore.setString("Par_Modalidad", bean.getModalidad());


					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
					sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
					sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
					sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
					sentenciaStore.setString("Aud_ProgramaID","ClienteArchivosDAO");
					sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
					sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMASEGUROVIDAACT(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
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
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de esquemas de seguro de vida.", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de metodo actualizacion

}
