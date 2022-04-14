package soporte.dao;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;


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

import soporte.bean.ParametrosYangaBean;




public class ParametrosYangaDAO extends BaseDAO {

	public ParametrosYangaDAO(){
		super();
	}



	/*=============================== METODOS ==================================*/



	/* Consuta Principal (por empresaID), obtiene todos los parametros de yanga*/

	public ParametrosYangaBean consultaPrincipal(ParametrosYangaBean parametrosYanga,int tipoConsulta) {
		ParametrosYangaBean parametrosYangaBean= new ParametrosYangaBean();

		try{

			/*Query con el Store Procedure */
			String query = "call PARAMETROSYANGACON(?,?,?,?,?, ?,?,?);";

			Object[] parametros = { parametrosYanga.getEmpresaID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO };	//	numTransaccion

			/*Registra el  inf. del log */
			loggerSAFI.info("call PARAMETROSYANGACON(" + Arrays.toString(parametros) + ")");


			/*E]ecuta el query y setea los valores al bean*/
			List matches = jdbcTemplate.query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
								ParametrosYangaBean parametrosYangaBean = new ParametrosYangaBean();

								parametrosYangaBean.setEmpresaID(resultSet.getString("EmpresaID"));
								parametrosYangaBean.setCtaProtecCre(resultSet.getString("CtaProtecCre"));
								parametrosYangaBean.setCtaProtecCta(resultSet.getString("CtaProtecCta"));
								parametrosYangaBean.setHaberExSocios(resultSet.getString("HaberExsocios"));
								parametrosYangaBean.setCtaContaPROFUN(resultSet.getString("CtaContaPROFUN"));
								parametrosYangaBean.setTipoCtaProtec(resultSet.getString("TipoCtaProtec"));
								parametrosYangaBean.setMontoMaxProtec(resultSet.getString("MontoMaxProtec"));
								parametrosYangaBean.setMontoPROFUN(resultSet.getString("MontoPROFUN"));
								parametrosYangaBean.setAporteMaxPROFUN(resultSet.getString("AporteMaxPROFUN"));
								return parametrosYangaBean;
						}// trows ecexeption
			});//lista



			parametrosYangaBean= matches.size() > 0 ? (ParametrosYangaBean) matches.get(0) : null;

			/*Maneja la exception y registra el log de error */
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error("error en consulta principal de parametros yanga ", e);
		}


		/*Retorna un objeto cargado de datos */
		return parametrosYangaBean;
	}// consultaPrincipal





/* Modificacion de todos los parametros YANGA */

public MensajeTransaccionBean modificar(final ParametrosYangaBean parametrosYangaBean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

	transaccionDAO.generaNumeroTransaccion();

	mensaje = (MensajeTransaccionBean)transactionTemplate.execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {

				/* Query con el Store Procedure */
				mensajeBean = (MensajeTransaccionBean) jdbcTemplate.execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call PARAMETROSYANGAMOD(" +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_EmpresaID",Utileria.convierteEntero(parametrosYangaBean.getEmpresaID()));
							sentenciaStore.setString("Par_CtaProtecCre", parametrosYangaBean.getCtaProtecCre());
							sentenciaStore.setString("Par_CtaProtecCta",parametrosYangaBean.getCtaProtecCta());
							sentenciaStore.setString("Par_HaberExSocios",parametrosYangaBean.getHaberExSocios());
							sentenciaStore.setString("Par_CtaContaPROFUN",parametrosYangaBean.getCtaContaPROFUN());
							sentenciaStore.setInt("Par_TipoCtaProtec",Utileria.convierteEntero(parametrosYangaBean.getTipoCtaProtec()));
							sentenciaStore.setDouble("Par_MontoMaxProtec",Utileria.convierteDoble(parametrosYangaBean.getMontoMaxProtec()));
							sentenciaStore.setDouble("Par_MontoPROFUN",Utileria.convierteDoble(parametrosYangaBean.getMontoPROFUN()));
							sentenciaStore.setDouble("Par_AporteMaxPROFUN",Utileria.convierteDoble(parametrosYangaBean.getAporteMaxPROFUN()));

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info("call PARAMETROSYANGAMOD(" + sentenciaStore.toString() + ")");

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
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
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
					e.printStackTrace();
					loggerSAFI.error("error en modifica parametros de YANGA", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});



		return mensaje;
	}


}//class