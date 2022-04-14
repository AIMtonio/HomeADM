package cliente.dao;

import general.dao.BaseDAO;
import cliente.bean.RepEstadisticoBean;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import herramientas.OperacionesFechas;
import herramientas.Utileria;



public class RepEstadisticoDAO extends BaseDAO {
	
	//Llamado para reporte excel consulta 5
			public List <RepEstadisticoBean> repEstadisticoDetCartera(final RepEstadisticoBean repEstadisticoBean){
				List<RepEstadisticoBean> repEstadistico = null;
				
				try {
					String query="call ESTADISTICOCUENTASREP(?,?,?,?,?,?,	?,?,?,?,?,?,?)";
					Object[] parametros={
			
					repEstadisticoBean.getTipoReporte(),
					repEstadisticoBean.getFechaCorte(),
					repEstadisticoBean.getDetReporte(),
					repEstadisticoBean.getIncluirGL(),
					repEstadisticoBean.getSaldoMinimo(),
					repEstadisticoBean.getIncluirCuentaSA(),
							
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion(),
				};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESTADISTICOCUENTASREP("+ Arrays.toString(parametros)+")");
				List<RepEstadisticoBean> matches=((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
						RepEstadisticoBean repEstadisticoBean = new RepEstadisticoBean();
						
						repEstadisticoBean.setNumCredito(resultSet.getString("CreditoID"));
						repEstadisticoBean.setNomCliente(resultSet.getString("NombreCompleto"));
						repEstadisticoBean.setProducto(resultSet.getString("Descripcion"));
						repEstadisticoBean.setMontoCredito(resultSet.getString("MontoCredito"));
						repEstadisticoBean.setSaldoCapital(resultSet.getString("SaldoCapital"));
						repEstadisticoBean.setSaldo(resultSet.getString("SaldoInteres"));
						repEstadisticoBean.setSucursalID(resultSet.getString("NombreSucurs"));
						repEstadisticoBean.setClienteID(resultSet.getString("ClienteID"));

						return repEstadisticoBean;
					}	
				});
				repEstadistico = matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte estadistico", e);
				}
				return repEstadistico;
			}
	
	//Llamado para reporte excel consulta 7
		public List <RepEstadisticoBean> repEstadisticoDetCap(final RepEstadisticoBean repEstadisticoBean){
			List<RepEstadisticoBean> repEstadistico = null;
			
			try {
				String query="call ESTADISTICOCUENTASREP(?,?,?,?,?,?,	?,?,?,?,?,?,?)";
				Object[] parametros={
		
				repEstadisticoBean.getTipoReporte(),
				repEstadisticoBean.getFechaCorte(),
				repEstadisticoBean.getDetReporte(),
				repEstadisticoBean.getIncluirGL(),
				repEstadisticoBean.getSaldoMinimo(),
				repEstadisticoBean.getIncluirCuentaSA(),
						
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion(),
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESTADISTICOCUENTASREP("+ Arrays.toString(parametros)+")");
			List<RepEstadisticoBean> matches=((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
					RepEstadisticoBean repEstadisticoBean = new RepEstadisticoBean();
					
					repEstadisticoBean.setNumCuenta(resultSet.getString("NumCuenta"));
					repEstadisticoBean.setNomCliente(resultSet.getString("NombreCliente"));
					repEstadisticoBean.setDescripcion(resultSet.getString("Descripcion"));
					repEstadisticoBean.setEstatus(resultSet.getString("Estatus"));
					repEstadisticoBean.setProducto(resultSet.getString("Producto"));
					repEstadisticoBean.setTipoProducto(resultSet.getString("TipoProducto"));
					repEstadisticoBean.setSaldo(resultSet.getString("Importe"));
					repEstadisticoBean.setSaldoGL(resultSet.getString("SaldoGarantias"));
					repEstadisticoBean.setSucursalID(resultSet.getString("Sucursal"));
					repEstadisticoBean.setClienteID(resultSet.getString("ClienteID"));

		
					return repEstadisticoBean;
				}	
			});
			repEstadistico = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte estadistico", e);
			}
			return repEstadistico;
		}
		
	//Llamado para reporte excel consulta 6
		public List <RepEstadisticoBean> repEstadisticoSumCartera(final RepEstadisticoBean repEstadisticoBean){
			List<RepEstadisticoBean> repEstadistico = null;
			
			try {
				String query="call ESTADISTICOCUENTASREP(?,?,?,?,?,?,	?,?,?,?,?,?,?)";
				Object[] parametros={
		
				repEstadisticoBean.getTipoReporte(),
				repEstadisticoBean.getFechaCorte(),
				repEstadisticoBean.getDetReporte(),
				repEstadisticoBean.getIncluirGL(),
				repEstadisticoBean.getSaldoMinimo(),
				repEstadisticoBean.getIncluirCuentaSA(),
						
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion(),
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESTADISTICOCUENTASREP("+ Arrays.toString(parametros)+")");
			List<RepEstadisticoBean> matches=((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
					RepEstadisticoBean repEstadisticoBean = new RepEstadisticoBean();
					
					repEstadisticoBean.setCantidadRegistros(resultSet.getString("Cantidad"));
					repEstadisticoBean.setProducto(resultSet.getString("Descripcion"));
					repEstadisticoBean.setMontoCredito(resultSet.getString("MontoCredito"));
					repEstadisticoBean.setSaldoCapital(resultSet.getString("SaldoCapital"));
					repEstadisticoBean.setSaldo(resultSet.getString("SaldoIntereses"));
					
					return repEstadisticoBean;
				}	
			});
			repEstadistico = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte estadistico", e);
			}
			return repEstadistico;
		}
	
	//Llamado para reporte excel consulta 8
	public List <RepEstadisticoBean> repEstadisticoSumCap(final RepEstadisticoBean repEstadisticoBean){
		List<RepEstadisticoBean> repEstadistico = null;
		
		try {
			String query="call ESTADISTICOCUENTASREP(?,?,?,?,?,?,	?,?,?,?,?,?,?)";
			Object[] parametros={
	
			repEstadisticoBean.getTipoReporte(),
			repEstadisticoBean.getFechaCorte(),
			repEstadisticoBean.getDetReporte(),
			repEstadisticoBean.getIncluirGL(),
			repEstadisticoBean.getSaldoMinimo(),
			repEstadisticoBean.getIncluirCuentaSA(),
					
			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			parametrosAuditoriaBean.getNombrePrograma(),
			parametrosAuditoriaBean.getSucursal(),
			parametrosAuditoriaBean.getNumeroTransaccion(),
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESTADISTICOCUENTASREP("+ Arrays.toString(parametros)+")");
		List<RepEstadisticoBean> matches=((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
				RepEstadisticoBean repEstadisticoBean = new RepEstadisticoBean();
				
				repEstadisticoBean.setCantidadRegistros(resultSet.getString("Cantidad"));
				repEstadisticoBean.setProducto(resultSet.getString("Descripcion"));
				repEstadisticoBean.setTipoProducto(resultSet.getString("TipoProducto"));
				repEstadisticoBean.setSaldo(resultSet.getString("Saldo"));
				repEstadisticoBean.setSaldoGL(resultSet.getString("GarantiaLiquida"));
				
	
				return repEstadisticoBean;
			}	
		});
		repEstadistico = matches;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte estadistico", e);
		}
		return repEstadistico;
	}

}

