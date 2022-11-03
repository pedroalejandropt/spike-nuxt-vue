import { shallowMount } from "@vue/test-utils";
import Compound from "@/components/Compound.vue";

describe("Compound.vue", () => {
  it("renders props.msg when passed", () => {
    const msg = "new message";
    const wrapper = shallowMount(Compound, {
      props: { msg },
    });
    expect(wrapper.text()).toMatch(msg);
  });
});
