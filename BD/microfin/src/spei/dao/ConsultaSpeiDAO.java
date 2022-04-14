	package spei.dao;

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

import spei.bean.ConsultaSpeiBean;

	public class ConsultaSpeiDAO extends BaseDAO  {
		
		ConsultaSpeiDAO consultaSpeiDAO = null; 
		
		public ConsultaSpeiDAO() {
			super();
		}
		
	
	/* lista para traer los envios spei*/		
		public List listaPrincipal(ConsultaSpeiBean consultaSpeiBean, int tipoLista){
			String query = "call SPEIENVIOSLIS(?,?,?,?,?,?, ?,?,?,?,?,?,?,?);";
			Object[] parametros = {
						consultaSpeiBean.getFolio(),
						consultaSpeiBean.getClienteID(),
						consultaSpeiBean.getFechaInicial(),
						consultaSpeiBean.getFechaFinal(),
						consultaSpeiBean.getEstatus(),
						Constantes.STRING_VACIO,
						tipoLista,
						
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						Constantes.STRING_VACIO,
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEIENVIOSLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsultaSpeiBean consultaSpeiBean = new ConsultaSpeiBean();
					consultaSpeiBean.setFecha(resultSet.getString(1)); 
					consultaSpeiBean.setMontoSpei(resultSet.getString(2));
					consultaSpeiBean.setProcesado(resultSet.getString(3));
					consultaSpeiBean.setEstatus(resultSet.getString(4));
					
					
					return consultaSpeiBean;
					
					
				}
			});
			return matches;
		}

		
		/* lista para traer las remesas */		
			public List listaRecepciones(ConsultaSpeiBean consultaSpeiBean, int tipoLista){
				String query = "call SPEIRECEPCIONESLIS(?,?,?,?,?, ?,?,?,?,?);";
				Object[] parametros = {
						    Constantes.ENTERO_CERO,
							Constantes.STRING_VACIO,
							tipoLista,
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							Constantes.STRING_VACIO,
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEIRECEPCIONESLIS(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ConsultaSpeiBean consultaSpeiBean = new ConsultaSpeiBean();
						consultaSpeiBean.setFecha(resultSet.getString(1)); 
						consultaSpeiBean.setMontoSpei(resultSet.getString(2));
						consultaSpeiBean.setProcesado(resultSet.getString(3));
						consultaSpeiBean.setEstatus(resultSet.getString(4));
						
						return consultaSpeiBean;
						
						
					}
				});
				return matches;
			}

			/*lista para traer los saldos*/
			public List listaSaldos(ConsultaSpeiBean consultaSpeiBean, int tipoLista){
				String query = "call SPEISALDOSLIS(?,?,?,?,?, ?,?,?);";
				Object[] parametros = {
						    consultaSpeiBean.getEmpresaID(),
							tipoLista,
							
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							Constantes.STRING_VACIO,
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEISALDOSLIS(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ConsultaSpeiBean consultaSpeiBean = new ConsultaSpeiBean();
						consultaSpeiBean.setSaldoActual(resultSet.getString(1)); 
						consultaSpeiBean.setSaldoReservado(resultSet.getString(2));
						consultaSpeiBean.setMontoDisponible(resultSet.getString(3));
						consultaSpeiBean.setBalanceCuenta(resultSet.getString(4));
						
						return consultaSpeiBean;
						
						
					}
				});
				return matches;
			}
			
			public ConsultaSpeiBean consultaSaldoActual(int empresaID, int tipoConsulta){
				
				String query = "call SPEISALDOSCON(?,?,?,?,?,?,?,?);";
				Object[] parametros = {	empresaID,
										tipoConsulta,
										parametrosAuditoriaBean.getUsuario(),
										parametrosAuditoriaBean.getFecha(),
										parametrosAuditoriaBean.getDireccionIP(),
										Constantes.STRING_VACIO,
										parametrosAuditoriaBean.getSucursal(),
										parametrosAuditoriaBean.getNumeroTransaccion()
										};
				
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEISALDOSCON(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ConsultaSpeiBean consultaSpeiBean = new ConsultaSpeiBean();
						consultaSpeiBean.setSaldoActual(String.valueOf(resultSet.getString(1)));
						return consultaSpeiBean;
					}
				});
				
				return matches.size() > 0 ? (ConsultaSpeiBean) matches.get(0) : null;
			}
			
			
		public ConsultaSpeiDAO getConsultaSpeiDAO() {
			return consultaSpeiDAO;
		}


		public void setConsultaSpeiDAO(ConsultaSpeiDAO consultaSpeiDAO) {
			this.consultaSpeiDAO = consultaSpeiDAO;
		}

		




		
	}



