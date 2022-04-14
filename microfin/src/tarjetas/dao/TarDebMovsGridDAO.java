package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import tarjetas.bean.TarDebMovsGridBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TarDebMovsGridDAO extends BaseDAO {
	
	public TarDebMovsGridDAO() {
		super();
	}
	
	public List listaConsultaMovs(TarDebMovsGridBean tarDebMovsGrid, int tipoConsulta) {
		List listaConsulta = null;
		try {
			String query = "call TARDEBCONCILIAMOVSCON(?,?,?,?,?,?,?,?);";
			
			Object[] parametros = {
					tipoConsulta, 
					Constantes.ENTERO_CERO, 
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaConsultaMovsTarjetas", 
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call TARDEBCONCILIAMOVSCON(" + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TarDebMovsGridBean movimientosGridBean = new TarDebMovsGridBean();
					// Datos de la tabla TARDEBCONCILIAMOVS
					movimientosGridBean.setTarDebMovID(resultSet.getString("TarDebMovID"));
					movimientosGridBean.setTipoOperacionID(resultSet.getString("TipoOperacion"));
					movimientosGridBean.setDescOperacion(resultSet.getString("DescOperacion"));
					movimientosGridBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
					movimientosGridBean.setMontoOperacion(resultSet.getString("MontoOperacion"));
					movimientosGridBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
					movimientosGridBean.setNumReferencia(resultSet.getString("NumReferencia"));
					
					// Datos de la tabla TARDEBTMPMOVS
					movimientosGridBean.setConciliaID(resultSet.getString("ConciliaID"));
					movimientosGridBean.setDetalleID(resultSet.getString("DetalleID"));
					movimientosGridBean.setNumCuenta(resultSet.getString("TarjetaDebIDExt"));
					movimientosGridBean.setFechaConsumo(resultSet.getString("FechaConsumoExt"));
					movimientosGridBean.setFechaProceso(resultSet.getString("FechaProcesoExt"));
					movimientosGridBean.setTipoTransaccion(resultSet.getString("TipoTransaccionExt"));
					movimientosGridBean.setDescTipoTransaccion(resultSet.getString("DescOperacionExt"));
					movimientosGridBean.setImporteOrigenTrans(resultSet.getString("MontoOperacionExt"));
					movimientosGridBean.setNumAutorizacion(resultSet.getString("NumAutorizacionExt"));
					movimientosGridBean.setEstatusConci(resultSet.getString("EstatusConci"));
					return movimientosGridBean;
				}
			});
			listaConsulta = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista de consulta de movimientos ", e);
		}
		return listaConsulta;
	}
}
