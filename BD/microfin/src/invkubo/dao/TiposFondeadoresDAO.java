package invkubo.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import herramientas.Constantes;
import herramientas.Utileria;
import invkubo.bean.TiposFondeadoresBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

 


public class TiposFondeadoresDAO extends BaseDAO{
	
	public TiposFondeadoresDAO() {
		super();
	}
	
/*------------Alta de Fondeadores-------------*/
	
		public MensajeTransaccionBean alta(final TiposFondeadoresBean tiposFondeadoresBean) {

			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					
/*---------------Query con el SP-------------*/
					String query = "call TIPOSFONDEADORESALT(?,?,?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							
							tiposFondeadoresBean.getDescripcion(),
							tiposFondeadoresBean.getEsObligadoSol(),
							tiposFondeadoresBean.getPagoEnIncumple(),
							Utileria.convierteDoble(tiposFondeadoresBean.getPorcentajeMora()),
							Utileria.convierteDoble(tiposFondeadoresBean.getPorcentajeComisi()),
							
																	
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSFONDEADORESALT(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de tipo fondeador", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
		/* Modificacion del Cliente */
		public MensajeTransaccionBean modifica(final TiposFondeadoresBean tiposFondeadores) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						
						//Query cons el Store Procedure
						String query = "call TIPOSFONDEADORESMOD(?,?,?,?,?,?,?,?,?,?,?,?,?);";
						Object[] parametros = {	
						Utileria.convierteEntero(tiposFondeadores.getTipoFondeadorID()),
						tiposFondeadores.getDescripcion(),
						tiposFondeadores.getEsObligadoSol(),
						tiposFondeadores.getPagoEnIncumple(),
						Utileria.convierteDoble(tiposFondeadores.getPorcentajeMora()),
						Utileria.convierteDoble(tiposFondeadores.getPorcentajeComisi()),
						
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						
						};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSFONDEADORESMOD(" + Arrays.toString(parametros) + ")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de tipo fondeador", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}
		
		/*-------Baja de Fondeadores-------*/
		
		public MensajeTransaccionBean  baja(final TiposFondeadoresBean tiposFondeadores) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
		/*--------Baja con SP---------*/
						String query = "call TIPOSFONDEADORESBAJ(?,?,?,?,?,?,?,?);";
						Object[] parametros = {
								Utileria.convierteEntero(tiposFondeadores.getTipoFondeadorID()),
								
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
						
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSFONDEADORESBAJ(" + Arrays.toString(parametros) + ")");
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de tipo de fondeador", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}
		/*---------consultas--------*/
		
		public TiposFondeadoresBean consultaPrincipal(TiposFondeadoresBean tiposFondeadores, int tipoConsulta) {
			// TODO Auto-generated method stub
			String query = "call TIPOSFONDEADORESCON(?,?,?,?,?,?,?,?,?);";
							
						Object[] parametros = { tiposFondeadores.getTipoFondeadorID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TiposFodeadoresDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSFONDEADORESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TiposFondeadoresBean tiposFondeadores = new TiposFondeadoresBean();
					tiposFondeadores.setTipoFondeadorID(String.valueOf(resultSet.getInt(1)));
					tiposFondeadores.setDescripcion(resultSet.getString(2));
					tiposFondeadores.setEsObligadoSol(resultSet.getString(3));					
					tiposFondeadores.setPagoEnIncumple(resultSet.getString(4));
					tiposFondeadores.setPorcentajeMora(resultSet.getString(5));
					tiposFondeadores.setPorcentajeComisi(resultSet.getString(6));
					return tiposFondeadores;
	
			}
		});
				
		return matches.size() > 0 ? (TiposFondeadoresBean) matches.get(0) : null;
	}
		

		public TiposFondeadoresBean consultaForanea(
				TiposFondeadoresBean tiposFondeadores, int tipoConsulta) {
			// TODO Auto-generated method stub
			return null;
		}

		
						
								
	}
				

