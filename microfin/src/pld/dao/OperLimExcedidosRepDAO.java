package pld.dao;


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
	import org.springframework.jdbc.core.JdbcTemplate;
	import org.springframework.transaction.support.TransactionTemplate;
	import org.springframework.transaction.TransactionStatus;
	import org.springframework.transaction.support.TransactionCallback;

	import pld.bean.OperLimExcedidosRepBean;
	import general.bean.ParametrosSesionBean;

	public class OperLimExcedidosRepDAO extends BaseDAO {
		ParametrosSesionBean parametrosSesionBean;
		
		public OperLimExcedidosRepDAO(){
			super();
		}

		/*=============================== METODOS ==================================*/

	
		/* metodo de lista para obtener los datos para el reporte */
	  public List listaReporte(final OperLimExcedidosRepBean operLimExcedidosRep, int tipoReporte){	
			List ListaResultado=null;
			
			try{
			String query = "CALL LIMEXEFECLIMESREP(?,?,?,?,?,  ?,?,?,?,?, "
												+ "?,?)";
			Object[] parametros ={
								Utileria.convierteFecha(operLimExcedidosRep.getFechaInicio()),
								Utileria.convierteFecha(operLimExcedidosRep.getFechaFin()),
								operLimExcedidosRep.getMonto(),
								operLimExcedidosRep.getTipoPersona(),
								tipoReporte,							
					    		
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
			

			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL LIMEXEFECLIMESREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OperLimExcedidosRepBean operLimExcedidosRepBean= new OperLimExcedidosRepBean();
					
					operLimExcedidosRepBean.setNombreCliente(resultSet.getString("NombreCliente"));
					operLimExcedidosRepBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					operLimExcedidosRepBean.setDescripcionOp(resultSet.getString("DescripcionOp"));
					operLimExcedidosRepBean.setCargo(resultSet.getString("Cargo"));
					operLimExcedidosRepBean.setAbono(resultSet.getString("Abono"));
					operLimExcedidosRepBean.setSaldoMes(resultSet.getString("SaldoMes"));
					operLimExcedidosRepBean.setNombreSucurs(resultSet.getString("NombreSucurs"));
					operLimExcedidosRepBean.setFecha(resultSet.getString("Fecha"));
					operLimExcedidosRepBean.setLimOrigen(resultSet.getString("LimOrigen"));
					operLimExcedidosRepBean.setNumTransaccion(resultSet.getString("NumTransaccion"));
					
					return operLimExcedidosRepBean ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Operacione con limites excedios", e);
			}
			return ListaResultado;
		}// fin lista report 
		

		public ParametrosSesionBean getParametrosSesionBean() {
			return parametrosSesionBean;
		}

		public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
			this.parametrosSesionBean = parametrosSesionBean;
		}



	}// fin clase

