import { createRouter, createWebHashHistory } from "vue-router";

const routes = [
  {
    path: "/",
    name: "home",
    component: () =>
      import(/* webpackChunkName: "Compounent-View" */ "@/components/Compound"),
    props: () => {
      return { msg: "Welcome to ChemSpider POC" };
    },
  },
  {
    path: "/:id",
    name: "entry",
    component: () =>
      // eslint-disable-next-line
      import(/* webpackChunkName, "Compounent-Data" */ "@/components/CompoundData"),
    props: (route) => {
      console.log(route);
      const id = route.params.id;
      return { id };
    },
  },
  {
    path: "/404",
    name: "error",
    component: () =>
      import(/* webpackChunkName: "Error-View" */ "@/components/Error"),
    props: () => {
      return { msg: "404 Page not found" };
    },
  },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;
