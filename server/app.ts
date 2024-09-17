import express from "express";
import cors from "cors";
import { envs } from "./envs";
import { prisma } from "./data/";

const app = express();
app.use(cors());

const port = envs.PORT;

app.get("/", async (req, res) => {
  const getProducts = await prisma.productos.findMany();
  let productNumber:number = 0;
  const ProductsMap = getProducts.map((product) => {
    productNumber++;
    return {
      numero: `Producto ${productNumber}`,
      codigo: product.codigo,
      nombre: product.nombre,
      descripcion: product.descripcion,
      cantidad: product.cantidad,
      stockmax: product.stockmax,
      srockmin: product.srockmin,
      precio: product.precio,
      codcat: product.codcat,
    };
  });
  res.json(ProductsMap);
});

app.delete("/:id", async (req, res) => {
  const id = req.params.id
  await prisma.productos
    .delete({ where: { codigo: id } })
    .then(() => {
      res.json("ok");
    })
    .catch((error) => res.status(400).json({ error }));
});

app.listen(port);
console.log("listening for port: ", port);
